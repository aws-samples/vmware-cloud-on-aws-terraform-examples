# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Deploy a VMware Cloud on AWS software-defined data center (SDDC)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ---------------------------------------------------------------------------------------------------------------------
# Configure the Terraform session
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  required_providers {
    vmc = {
      source  = "vmware/vmc"
      version = ">= 1.4.0"
    }
  }
  required_version = ">= 0.13"
}

# ---------------------------------------------------------------------------------------------------------------------
# Configure the Terraform providers
# ---------------------------------------------------------------------------------------------------------------------

# https://registry.terraform.io/providers/vmware/vmc/latest/docs
provider "vmc" {
  refresh_token = var.api_token
  org_id        = var.org_id
}

# ---------------------------------------------------------------------------------------------------------------------
# Local variables
# ---------------------------------------------------------------------------------------------------------------------

locals {
  sddc_type = var.num_host == 1 ? "1NODE" : "DEFAULT"

  # Uses the number of VPC subnets specified to determine whether to provision a stretched cluster for convenience.
  deployment_type = length(var.vpc_subnet_ids) > 1 ? "MultiAZ" : "SingleAZ"
}

# ---------------------------------------------------------------------------------------------------------------------
# Data sources
# ---------------------------------------------------------------------------------------------------------------------

data "vmc_connected_accounts" "account" {
  account_number = var.aws_account_number
}

data "vmc_customer_subnets" "subnets" {
  connected_account_id = data.vmc_connected_accounts.account.id
  region               = var.sddc_region
}

# ---------------------------------------------------------------------------------------------------------------------
# Create the VMware Cloud on AWS SDDC
# ---------------------------------------------------------------------------------------------------------------------

resource "vmc_sddc" "sddc" {
  provider_type = "AWS"
  region        = var.sddc_region

  sddc_type           = local.sddc_type
  deployment_type     = local.deployment_type
  size                = var.management_virtual_appliance_size
  sddc_name           = var.sddc_name
  vpc_cidr            = var.management_subnet
  host_instance_type  = var.host_instance_type
  num_host            = var.num_host
  vxlan_subnet        = var.default_subnet
  skip_creating_vxlan = false
  sso_domain          = var.sso_domain
  delay_account_link  = false

  account_link_sddc_config {
    customer_subnet_ids  = var.vpc_subnet_ids
    connected_account_id = data.vmc_connected_accounts.account.id
  }

  enable_edrs      = var.enable_edrs
  edrs_policy_type = var.edrs_policy_type
  min_hosts        = var.min_hosts
  max_hosts        = var.max_hosts

  lifecycle {
    prevent_destroy = true

    # If you plan to use the Elastic Distributed Resource Scheduler feature (eDRS) for automatically scaling the
    # vSphere cluster, uncomment the setting below to prevent subsequent runs from making unintended adjusts to the
    # number of ESXi hosts.
    # ignore_changes = [
    #   num_host,
    # ]
  }
}
