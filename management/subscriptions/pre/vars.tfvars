subscription_env = "pre"
resource_group_location = "westeurope"
gh_pat = "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"


# Networking
vnet_dns_servers                         = ["10.172.255.4"]
#vnet_dns_servers                          = []

ghr_vnet_address_prefix                   = "10.173.13.0/24"
gh_runners_subnet_address_prefix          = "10.173.13.48/28"

environments = [
    {
      env_name = "pre"
      vnet_address_prefix = "10.172.13.0/24"
    }
]

