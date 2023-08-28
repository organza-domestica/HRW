data "azurerm_client_config" "current" {}

locals {
  rg_name                   = "az-lx-rg-hrw-${var.environment}"
  aks_name                  = "az-lx-aks-hrw-${var.environment}"
  cr_name                   = "azlxcrhrw${var.environment}"
  application_client_id     = data.azurerm_client_config.current.client_id
  application_client_secret = var.azure_kv_sp_secret

  /* Worker - Service Principal */
  kubelogin_cmd = "./exec/kubelogin"
  kubelogin_args = [
    "get-token",
    "--login",
    "spn",
    "--environment",
    "AzurePublicCloud",
    "--tenant-id",
    data.azurerm_client_config.current.tenant_id,
    "--server-id",
    "6dae42f8-4368-4678-94ff-3960e28e3630", # https://github.com/Azure/kubelogin#exec-plugin-format
    "--client-id",
    data.azurerm_client_config.current.client_id,
    "--client-secret",
    var.service_principal_secret
  ]

  /* Local - Azure CLI 
  kubelogin_cmd  = "kubelogin"
  kubelogin_args = [
        "get-token",
        "--login",
        "azurecli",
        "--server-id",
        "6dae42f8-4368-4678-94ff-3960e28e3630", # https://github.com/Azure/kubelogin#exec-plugin-format
      ]
  */
}

# TODO: Ten data source i conditionale przy username, password, client_certificate, client_key do usuniecia z providerow  "kubernetes", "helm" i "kubectl" po migracji wszystkich klastrow na uwierzytelnianie AAD
# Docelowo powinien zostac host, cluster_ca_certificate i exec (tak jak aktualnie ale bez dynamic i for each)
# Aktualna konfiguracja zrobiona w celu wsparcia tymczasowych roznych konfiguracji na roznych srodowiskach
data "azurerm_kubernetes_cluster" "k8s" {
  name                = local.aks_name
  resource_group_name = local.rg_name
}

data "azurerm_container_registry" "cr" {
  name                = local.cr_name
  resource_group_name = local.rg_name
}

resource "time_sleep" "wait_for_k8s" {
  depends_on      = [data.azurerm_kubernetes_cluster.k8s]
  create_duration = "30s"
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.k8s.kube_config.0.host
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)

  username           = data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate == "" ? null : data.azurerm_kubernetes_cluster.k8s.kube_config.0.username
  password           = data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate == "" ? null : data.azurerm_kubernetes_cluster.k8s.kube_config.0.password
  client_certificate = data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate == "" ? null : base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)
  client_key         = data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate == "" ? null : base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)

  dynamic "exec" {
    for_each = data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate == "" ? [1] : []
    content {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = local.kubelogin_cmd
      args        = local.kubelogin_args
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.k8s.kube_config.0.host
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)

    username           = data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate == "" ? null : data.azurerm_kubernetes_cluster.k8s.kube_config.0.username
    password           = data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate == "" ? null : data.azurerm_kubernetes_cluster.k8s.kube_config.0.password
    client_certificate = data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate == "" ? null : base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)
    client_key         = data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate == "" ? null : base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)

    dynamic "exec" {
      for_each = data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate == "" ? [1] : []
      content {
        api_version = "client.authentication.k8s.io/v1beta1"
        command     = local.kubelogin_cmd
        args        = local.kubelogin_args
      }
    }
  }
}

# kubectl to allow yaml based manifests
provider "kubectl" {
  load_config_file       = false
  host                   = data.azurerm_kubernetes_cluster.k8s.kube_config.0.host
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)

  username           = data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate == "" ? null : data.azurerm_kubernetes_cluster.k8s.kube_config.0.username
  password           = data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate == "" ? null : data.azurerm_kubernetes_cluster.k8s.kube_config.0.password
  client_certificate = data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate == "" ? null : base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)
  client_key         = data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate == "" ? null : base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)

  dynamic "exec" {
    for_each = data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate == "" ? [1] : []
    content {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = local.kubelogin_cmd
      args        = local.kubelogin_args
    }
  }
}

resource "helm_release" "tigera-calico" {
  name             = "tigera-operator"
  namespace        = "tigera-operator"
  create_namespace = true
  depends_on       = [data.azurerm_kubernetes_cluster.k8s, time_sleep.wait_for_k8s]
  repository       = "https://projectcalico.docs.tigera.io/charts"
  chart            = "tigera-operator"
  version          = "3.25.1"
  timeout          = 180
  values = [
    file("helm/tigera-calico/values.yaml")
  ]
}

resource "time_sleep" "wait_for_calico" {
  depends_on      = [data.azurerm_kubernetes_cluster.k8s]
  create_duration = "60s"
}

#resource "helm_release" "monitoring" {
#  name             = "monitoring"
#  namespace        = "monitoring"
#  create_namespace = true
#  depends_on       = [helm_release.tigera-calico, time_sleep.wait_for_calico]
#  repository       = "https://prometheus-community.github.io/helm-charts"
#  chart            = "kube-prometheus-stack"
#}
#
#resource "helm_release" "loki" {
#  name       = "loki"
#  depends_on = [helm_release.tigera-calico, time_sleep.wait_for_calico]
#  repository = "https://grafana.github.io/helm-charts"
#  chart      = "loki-stack"
#}

#resource "helm_release" "workload-identity-webhook" {
#  name             = "workload-identity-webhook"
#  namespace        = "azure-workload-identity-system"
#  create_namespace = true
#  depends_on       = [helm_release.tigera-calico, time_sleep.wait_for_calico]
#  repository       = "https://azure.github.io/azure-workload-identity/charts"
#  chart            = "workload-identity-webhook"
#
#  set {
#    name  = "azureTenantID"
#    value = var.tenant_id
#  }
#}


#resource "helm_release" "external-secrets" {
#  name             = "external-secrets"
#  namespace        = "external-secrets"
#  create_namespace = true
#  depends_on       = [helm_release.tigera-calico, time_sleep.wait_for_calico]
#  repository       = "https://charts.external-secrets.io"
#  chart            = "external-secrets"
#}

resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true
  depends_on       = [helm_release.tigera-calico, time_sleep.wait_for_calico]
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.16.8"
  values = [
    file("helm/argocd/argocd-helm-values.yaml")
  ]
}

resource "kubernetes_secret_v1" "argocd_infra_repo" {
  depends_on = [
    helm_release.argocd
  ]
  metadata {
    name      = "lx-k8s-infra"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    "type"          = "git"
    "url"           = "git@github.com:organza-domestica/argocd-lx-environments-marian.git"
    "sshPrivateKey" = var.k8s_argocd_app_of_apps_repo_key
  }
}

resource "kubernetes_secret_v1" "argocd_helm_repo" {
  depends_on = [
    helm_release.argocd
  ]
  metadata {
    name      = "lx-helm-repo"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    "type"      = "helm"
    "name"      = "lxacr4net.io" # TODO perhaps choose better internal ArgoCD name for repo
    "url"       = "${data.azurerm_container_registry.cr.login_server}/helm"
    "enableOCI" = "true"
    "username"  = var.azure_acr_helm_username
    "password"  = var.azure_acr_helm_password
  }
}


#resource "kubernetes_service_account_v1" "workload-identity-sa" {
#  metadata {
#    name      = "workload-identity-sa"
#    namespace = "default"
#    annotations = {
#      "azure.workload.identity/client-id" : local.application_client_id
#      "azure.workload.identity/tenant-id" : var.tenant_id
#    }
#    labels = {
#      "azure.workload.identity/use" = "true"
#    }
#
#  }
#}

resource "kubectl_manifest" "namespace" {
  yaml_body = <<-EOF
    apiVersion: external-secrets.io/v1beta1
    kind: Namespace
    apiVersion: v1
    metadata:
      name: az-hrw-${var.environment}-ns
  EOF
}

#resource "kubectl_manifest" "external_secrets_azure_keyvault_secretstore" {
#  depends_on = [
#    #    kubernetes_service_account_v1.workload-identity-sa,
#    helm_release.external-secrets
#  ]
#  yaml_body = <<-EOF
#    apiVersion: external-secrets.io/v1beta1
#    kind: Namespace
#    apiVersion: v1
#    metadata:
#      name: az-hrw-${var.environment}-ns
#    
#    ---
#    
#    kind: SecretStore
#    metadata:
#      name: azurekv-secret-store
#      namespace: az-hrw-${var.environment}-ns
#    spec:
#      provider:
#        azurekv:
#          tenantId: ${var.tenant_id}
#          vaultUrl: ${var.kv_uri}
#          authSecretRef:
#            clientId:
#              name: azure-secret-sp
#              key: ClientID
#            clientSecret:
#              name: azure-secret-sp
#              key: ClientSecret
#  EOF
#}

resource "kubernetes_secret_v1" "lx-azurecr-io" {
  depends_on = [
    kubectl_manifest.namespace
  ]
  metadata {
    name      = "docker-registry-credentials"
    namespace = "az-hrw-${var.environment}-ns"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${data.azurerm_container_registry.cr.login_server}" = {
          "username" = data.azurerm_container_registry.cr.admin_username
          "password" = data.azurerm_container_registry.cr.admin_password
          "auth"     = base64encode("${data.azurerm_container_registry.cr.admin_username}:${data.azurerm_container_registry.cr.admin_password}")
        }
      }
    })
  }
}

resource "kubernetes_secret_v1" "azure-secret-sp" {
  depends_on = [
    helm_release.argocd,
    kubectl_manifest.namespace
  ]
  metadata {
    name      = "azure-secret-sp"
    namespace = "az-hrw-${var.environment}-ns"
  }

  data = {
    "ClientID"     = local.application_client_id
    "ClientSecret" = local.application_client_secret
  }
}

resource "kubectl_manifest" "argocd_4net_app_of_apps" {
  depends_on = [
    helm_release.argocd
  ]
  yaml_body = <<-EOF
    apiVersion: argoproj.io/v1alpha1
    kind: Application
    metadata:
      name: 4net-app-of-apps
      namespace: argocd
      finalizers:
        - resources-finalizer.argocd.argoproj.io
    spec:
      project: default
      source:
        helm:
          valueFiles:
          - env/azure-${var.environment}/${local.aks_name}.yaml
        path: apps
        repoURL: git@github.com:${var.githubuser}/argocd-lx-environments-${var.environment}.git
        targetRevision: main
      destination:
        server: https://kubernetes.default.svc
        namespace: argocd
      syncPolicy:
        automated:
          allowEmpty: false
        syncOptions:
        - CreateNamespace=true
        - PrunePropagationPolicy=foreground
        - PruneLast=true
  EOF
}

#resource "kubectl_manifest" "hrw_external_secrets" {
#  depends_on = [
#    helm_release.argocd
#  ]
#  yaml_body = <<-EOF
#    kind: Namespace
#    apiVersion: v1
#    metadata:
#      name: az-hrw-${var.environment}-ns
#    
#    ---
#    
#    apiVersion: external-secrets.io/v1beta1
#    kind: ExternalSecret
#    metadata:
#      name: hrw-secret
#      namespace: az-hrw-${var.environment}-ns
#    spec:
#      refreshInterval: 1h
#      secretStoreRef:
#        kind: SecretStore
#        name: azurekv-secret-store
#    
#      target:
#        name: hrw-secret
#        creationPolicy: Owner
#    
#      dataFrom:
#      - extract:
#          key: hrw-secret
#    
#  EOF
#}

data "azurerm_user_assigned_identity" "id" {
  name                = "az-lx-id-hrw-${var.environment}-aks"
  resource_group_name = local.rg_name
}

resource "kubernetes_config_map" "aks-config" {
  depends_on = [
    kubectl_manifest.argocd_4net_app_of_apps
  ]
  metadata {
    name      = "aks-config"
    namespace = "az-hrw-${var.environment}-ns"
  }

  data = {
    managed-identity-client-id = data.azurerm_user_assigned_identity.id.client_id
  }
}
