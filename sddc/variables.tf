# ---------------------------------------------------------------------------------------------------------------------
# Required parameters
# These variables do not have default values.
# ---------------------------------------------------------------------------------------------------------------------

variable "api_token" {
  type        = string
  description = "The VMware Cloud Services API token. This token is scoped within the organization."

  validation {
    condition     = can(regex("^[0-9a-zA-Z]{64}$", var.api_token))
    error_message = "Only the 64 character alphanumeric VMware Cloud API token is accepted."
  }
}

variable "org_id" {
  type        = string
  description = "The VMware Cloud long organization identifier (eg: 01234567-89ab-cdef-0123-456789abcdef)."

  validation {
    condition     = can(regex("^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$", var.org_id))
    error_message = "Only the long format organization identifier is accepted."
  }
}

variable "aws_account_number" {
  type        = string
  description = "The AWS account number that will be linked to the VMware Cloud on AWS account via AWS PrivateLink."

  validation {
    condition     = can(regex("^[0-9]{12}$", var.aws_account_number))
    error_message = "Only the 12 digit AWS account number is accepted."
  }
}

variable "sddc_region" {
  type        = string
  description = "The AWS Region in which the software-defined data center (SDDC) will be created (eg: US_EAST_1). In the VMware Cloud API, all letters must be uppercase for the Region and underscores ('_') are used instead of hyphens ('-')."

  validation {
    condition     = can(regex("^[A-Z]{2}_[A-Z]+_[0-9]$", var.sddc_region))
    error_message = "Only AWS Regions in the VMware Cloud API format are accepted (eg: US_WEST_2)."
  }
}

variable "sddc_name" {
  type        = string
  description = "The name of the SDDC."
}

variable "vpc_subnet_ids" {
  type        = list(string)
  description = "The Amazon Virtual Private Cloud (VPC) subnet identifier(s) that your SDDC will be connected to via AWS PrivateLink (eg: ['subnet-01234567']). Specify a list with one subnet ID for a standard single Availability Zone (AZ) SDDC, or a list of two subnet IDs (each in separate AZs) for a stretched cluster SDDC. Note: The AZ of each subnet determines where the SDDC's ESXi hosts will be deployed."
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional parameters
# These variables have defaults, but can be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "num_host" {
  type        = number
  description = "The number of ESXi hosts to deploy in the first SDDC cluster. Once scaled to 3+ hosts, the vSphere cluster can no longer be scaled back down below 3 hosts."
  default     = 1

  validation {
    condition     = var.num_host >= 1 && var.num_host <= 16 && floor(var.num_host) == var.num_host
    error_message = "Accepted values: 1-16."
  }
}

variable "management_virtual_appliance_size" {
  type        = string
  description = "The size of the vCenter and NSX appliances. The 'large' SDDC size corresponds to a large vCenter appliance and large NSX appliance, and the 'medium' SDDC size corresponds to medium vCenter appliance and medium NSX appliance."
  default     = "medium"

  validation {
    condition     = can(regex("^(?:medium|large)$", var.management_virtual_appliance_size))
    error_message = "Accepted values: 'medium' or 'large'."
  }
}

variable "host_instance_type" {
  type        = string
  description = "The instance type for the Amazon Elastic Cloud Compute (EC2) hosts in the primary cluster of the SDDC."
  default     = "I3_METAL"

  validation {
    condition     = can(regex("^I3(?:EN)?_METAL$", var.host_instance_type))
    error_message = "Accepted values: 'I3_METAL' or 'I3EN_METAL'."
  }
}

variable "management_subnet" {
  type        = string
  description = "The IPv4 CIDR block for the SDDC's management network. This private subnet range (RFC 1918) is used for the vCenter Server, NSX Manager, and ESXi hosts and only a prefix of '/16', '/20', or '/23' are supported. Choose a range that will not conflict with other networks you will connect to or use in this SDDC. A '/23' supports up to 27 hosts, '/20' supports up to 251 hosts, and '/16' supports up to 4091 hosts. Reserved CIDR blocks: '10.0.0.0/15' and '172.31.0.0/16'."
  default     = "10.2.0.0/16"

  validation {
    condition     = can(regex("^(?:192\\.168\\.(?:1?\\d?\\d|2[0-4]\\d|25[0-4])|172\\.(?:1[6-9]|2\\d|30)\\.(?:1?\\d?\\d|2[0-4]\\d|25[0-4])|10\\.(?:[2-9]|\\d{2}|1\\d{2}|2[0-4]\\d|25[0-4])\\.(?:1?\\d?\\d|2[0-4]\\d|25[0-4]))\\.0\\/(?:16|20|23)$", var.management_subnet))
    error_message = "Only 16-bit, 20-bit, and 23-bit RFC 1918 CIDR blocks are supported. Reserved CIDR blocks: '10.0.0.0/15' and '172.31.0.0/16'."
  }
}

variable "default_subnet" {
  type        = string
  description = "A routed logical network segment that will be created with the SDDC and connected to the VMware Cloud on AWS Compute Gateway (CGW)."
  default     = "192.168.1.0/24"

  validation {
    condition     = can(regex("^(?:(?:1?\\d?\\d|2[0-4]\\d|25[0-5])\\.){3}(?:1?\\d?\\d|2[0-4]\\d|25[0-5])\\/(?:[2-9]|[1-2]\\d|3[0-1])$", var.default_subnet))
    error_message = "Only a IPv4 CIDR block between 2-bit and 31-bit is supported, and it can't overlap with the management network specified in management_subnet or reserved CIDR block '172.31.0.0/16'."
  }
}

variable "sso_domain" {
  type        = string
  description = "The SSO domain name to use for vSphere users."
  default     = "vmc.local"
}

variable "enable_edrs" {
  type        = bool
  description = "Set this to true to enable the Elastic Distributed Resource Scheduler (eDRS) feature, which automatically adds or removes ESXi hosts for accommodating load and/or storage capacity."
  default     = false
}

variable "edrs_policy_type" {
  type        = string
  description = "The eDRS policy type."
  default     = "storage-scaleup"

  validation {
    condition     = contains(["cost", "performance", "storage-scaleup", "rapid-scaleup"], var.edrs_policy_type)
    error_message = "Accepted values: 'cost, 'performance', 'storage-scaleup', or 'rapid-scaleup'."
  }
}

variable "min_hosts" {
  type        = number
  description = "The minimum number of hosts to which eDRS can scale in the vSphere cluster."
  default     = 3

  validation {
    condition     = var.min_hosts >= 3 && var.min_hosts <= 16 && floor(var.min_hosts) == var.min_hosts
    error_message = "Accepted values: 3-16."
  }
}

variable "max_hosts" {
  type        = number
  description = "The maximum number of hosts to which eDRS can scale out the vSphere cluster."
  default     = 16

  validation {
    condition     = var.max_hosts >= 3 && var.max_hosts <= 16 && floor(var.max_hosts) == var.max_hosts
    error_message = "Accepted values: 3-16."
  }
}
