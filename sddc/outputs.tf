output "connected_account_id" {
  description = "The VMware Cloud identifier for the linked AWS account number."
  value       = data.vmc_connected_accounts.account.id
}

output "available_vpc_subnet_ids" {
  description = "The Amazon Virtual Private Cloud (VPC) subnet identifiers available in the linked AWS account in the specified Region."
  value       = sort(data.vmc_customer_subnets.subnets.ids)
}

output "is_valid_vpc_subnet_ids" {
  description = "Whether the specified VPC subnet identifier(s) were found in the list of available VPC subnet IDs in the connected AWS account in the specified Region."
  value       = { for i in sort(var.vpc_subnet_ids) : i => contains(data.vmc_customer_subnets.subnets.ids, i) }
}

output "sddc_id" {
  description = "The VMware Cloud on AWS software-defined data center (SDDC) identifier."
  value       = vmc_sddc.sddc.id
}

output "nsxt_reverse_proxy_url" {
  description = "The SDDC's NSX-T reverse proxy URL."
  value       = vmc_sddc.sddc.nsxt_reverse_proxy_url
}

output "cluster_info" {
  description = "Information about the vSphere cluster such as the identifier, name, state, and host instance type."
  value       = vmc_sddc.sddc.cluster_info
}

output "management_virtual_appliance_size" {
  description = "The size of the vCenter Server and NSX Manager virtual appliances."
  value       = vmc_sddc.sddc.sddc_size
}
