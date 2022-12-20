# jenkins-stack
<!-- BEGIN_TF_DOCS -->
## Setup
Since the repository contains git submodules, follow the below instructions prior to running the stack.
- cd [repository-directory]
- git submodule update --init --recursive

Now for the Terraform stack itself,
- Update my_ip_address within `terraform.tfvars`, this is used for SG's and access to Jenkins via HTTP & SSH (Use `127.0.0.1/32` format)
- Create SSH key within your account (or use an existing one) and provide key pair name within `terraform.tfvars` Jenkins declaration.

Deploy!
- Terraform init
- Terraform apply

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.45.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_basic-networking"></a> [basic-networking](#module\_basic-networking) | ./modules/basic-networking | n/a |
| <a name="module_jenkins"></a> [jenkins](#module\_jenkins) | ./modules/jenkins | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Availability Zones | `list` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment for networking setup | `any` | n/a | yes |
| <a name="input_my_ip_address"></a> [my\_ip\_address](#input\_my\_ip\_address) | My IP Address, used in SG for Jenkins access | `any` | n/a | yes |
| <a name="input_private_subnets_cidr"></a> [private\_subnets\_cidr](#input\_private\_subnets\_cidr) | CIDR for Private Subnets | `list` | n/a | yes |
| <a name="input_public_subnets_cidr"></a> [public\_subnets\_cidr](#input\_public\_subnets\_cidr) | CIDR for Public Subnets | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS Deployment region | `any` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR for VPC | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->