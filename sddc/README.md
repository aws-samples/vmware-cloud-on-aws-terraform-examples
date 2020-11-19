# Deploy a VMware Cloud on AWS SDDC

This example template will deploy a new [VMware Cloud on AWS][vmconaws] [software-defined data center (SDDC)][sddc] via [HashiCorp][hashicorp] [Terraform][terraform].

## Getting Started

### Prerequisites

1. [Terraform][tf_download]
1. [VMware Cloud on AWS account][vmconaws] and [console access][vmconaws_console]
1. [AWS account][aws_account] that will be linked with the VMware Cloud on AWS account via [AWS PrivateLink][privatelink]
    1. [Amazon Virtual Private Cloud (VPC) subnet(s)][aws_subnet]
        NOTE: The availability zone(s) (AZ(s)) of the subnet(s) determines the AZ(s) where the SDDC will be deployed.
1. [Configure the input variables to your specification][tf_vars]

### Deploy

1. [`terraform init`][tf_init]
1. [`terraform validate`][tf_validate]
1. [`terraform plan`][tf_plan]
    1. Review the results.
1. [`terraform apply`][tf_apply]

### Destroy

1. Either comment out the `vmc_sddc.sddc` resource's [`lifecycle.prevent_destroy`][tf_prevent_destroy] setting or set it to `false` to permit resource destruction
1. [`terraform destroy`][tf_destroy]

### Troubleshooting

* [Debugging Terraform][tf_debug]

## Additional Resources

* [Getting started with HashiCorp Terraform][tf_getting_started]
* [HashiCorp Terraform source code][tf_repo]
* [VMware Cloud on AWS documentation][vmconaws_docs]

[aws_account]: https://portal.aws.amazon.com/billing/signup#/start
[aws_subnet]: https://docs.aws.amazon.com/vpc/latest/userguide/working-with-vpcs.html#AddaSubnet
[hashicorp]: https://www.hashicorp.com/
[privatelink]: https://aws.amazon.com/privatelink/
[sddc]: https://docs.vmware.com/en/VMware-Cloud-on-AWS/services/com.vmware.vmc-aws-operations/GUID-A0F15ABA-C2DF-46CD-B883-A9FABD892B75.html
[terraform]: https://www.terraform.io/
[tf_apply]: https://www.terraform.io/docs/commands/apply.html
[tf_debug]: https://www.terraform.io/docs/internals/debugging.html
[tf_destroy]: https://www.terraform.io/docs/commands/destroy.html
[tf_download]: https://www.terraform.io/downloads.html
[tf_getting_started]: https://learn.hashicorp.com/terraform/getting-started/install.html
[tf_init]: https://www.terraform.io/docs/commands/init.html
[tf_plan]: https://www.terraform.io/docs/commands/plan.html
[tf_prevent_destroy]: https://www.terraform.io/docs/configuration/resources.html#prevent_destroy
[tf_repo]: https://github.com/hashicorp/terraform
[tf_validate]: https://www.terraform.io/docs/commands/validate.html
[tf_vars]: https://www.terraform.io/docs/configuration/variables.html#assigning-values-to-root-module-variables
[vmconaws]:https://aws.amazon.com/vmware/
[vmconaws_console]: https://vmc.vmware.com/console/sddcs
[vmconaws_docs]: https://docs.vmware.com/en/VMware-Cloud-on-AWS/index.html
