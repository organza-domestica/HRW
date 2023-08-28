//resource "azurerm_resource_group" "rg_gh_runners" {
//  count = var.existing_rg ? 0 : 1
//  location = var.resource_group_location
//  name     = "az-lx-rg-ghr-hrw-${var.subscription_env}"
//}
//
//data "azurerm_resource_group" "rg_gh_runners" {
//  count = var.existing_rg ? 1 : 0
//  name = var.existing_rg_name
//}

# get existing or new resource group name and location based on 'exisitng_rg' state
locals {
  //rg_name       = var.existing_rg ? one(data.azurerm_resource_group.rg_gh_runners[*].name) : one(azurerm_resource_group.rg_gh_runners[*].name)
  //rg_location   = var.existing_rg ? one(data.azurerm_resource_group.rg_gh_runners[*].location) : one(azurerm_resource_group.rg_gh_runners[*].location)
  rg_name     = var.rg_name
  rg_location = var.rg_location
}

# Create subnet
resource "azurerm_subnet" "snet_gh_runners_mgmt" {
  name                 = "az-lx-snet_gh_runners_mgmt-${var.subscription_env}"
  resource_group_name  = local.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.gh_runners_subnet_address_prefix]
}

## Create public IP - TODO delete and move to PrivateEndpoint
resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = "myPublicIP-${var.subscription_env}"
  location            = local.rg_location
  resource_group_name = local.rg_name
  allocation_method   = "Dynamic"
}

# Create NSG for SSH access - TODO set source address prefix
resource "azurerm_network_security_group" "nsg_gh_runners" {
  name                = "az-lx-nsg_gh_runners-${var.subscription_env}"
  location            = local.rg_location
  resource_group_name = local.rg_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "nic_gh_runner" {
  name                = "az-lx-nic-ghrunner-${var.subscription_env}"
  location            = local.rg_location
  resource_group_name = local.rg_name

  ip_configuration {
    name                          = "nic_configuration-${var.subscription_env}"
    subnet_id                     = azurerm_subnet.snet_gh_runners_mgmt.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  network_interface_id      = azurerm_network_interface.nic_gh_runner.id
  network_security_group_id = azurerm_network_security_group.nsg_gh_runners.id
}

## Generate random text for a unique storage account name
#resource "random_id" "random_id" {
#  keepers = {
#    # Generate a new ID only when a new resource group is defined
#    resource_group = local.rg_name
#  }
#
#  byte_length = 8
#}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "gh_storage_account" {
  name                     = "azlxstghrhrw${var.subscription_env}"
  location                 = local.rg_location
  resource_group_name      = local.rg_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create (and display) an SSH key
resource "tls_private_key" "auto_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "template_file" "linux-vm-cloud-init" {
  template = file("${path.module}/cloud-init.txt")
  vars = {
    gh_pat = var.gh_pat
    subscription_env = var.subscription_env
  }
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "vm_gh_runner" {
  name                  = "az-lx-vm-gh-runner-${var.subscription_env}"
  location              = local.rg_location
  resource_group_name   = local.rg_name
  network_interface_ids = [azurerm_network_interface.nic_gh_runner.id]
  size                  = "Standard_B2s"

  os_disk {
    name                 = "GitHubOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

# Finding a new image steps:
# az vm image list-publishers --location westeurope --output table
# az vm image list-offers --location westeurope --publisher RedHat --output table
# az vm image list-skus --location westeurope --publisher RedHat --offer RHEL --output table
  source_image_reference {
    publisher = "Oracle"
    offer     = "Oracle-Linux"
    sku       = "ol86-lvm"
    version   = "latest"
  }

  computer_name                   = "az-lx-vm-gh-runner-${var.subscription_env}"
  admin_username                  = "lxadmin"
  custom_data = base64encode(data.template_file.linux-vm-cloud-init.rendered)
  disable_password_authentication = true

  admin_ssh_key {
    username   = "lxadmin"
    public_key = tls_private_key.auto_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.gh_storage_account.primary_blob_endpoint
  }
}

