# Cloud SQL Database Example

This example shows how to create the public HA Postgres Cloud SQL cluster using the Terraform module.

## Run Terraform

Create resources with terraform:

```bash
terraform init
terraform plan
terraform apply
```

To remove all resources created by terraform:

```bash
terraform destroy
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| folder\_id | The folder where project is created | `string` | n/a | yes |
| key\_project\_id | The project where autokey is setup | `string` | n/a | yes |
| pg\_ha\_external\_ip\_range | The ip range to allow connecting from/to Cloud SQL | `string` | `"192.10.10.10/32"` | no |
| pg\_ha\_name | The name for Cloud SQL instance | `string` | `"tf-pg-ha"` | no |
| project\_id | The project to run tests against | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| authorized\_network | n/a |
| instances | n/a |
| name | The name for Cloud SQL instance |
| project\_id | n/a |
| replicas | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
