# Example 1 (EC2)

This example is based on [this](https://spacelift.io/blog/terraform-ecs#how-to-setup-ecs-with-terraform--example) tutorial.

This is a good basic example, but there are a few things that were left out of the provided write-up that made this a bit
challenging to understand. The biggest of which is this example uses an IAM role which they do not explain how or where
it is defined. If you are not familiar with AWS this will likely be a stumbling block as it doesn't tell you to go create
this role or explain how to do it in Terraform.

## Things that are different in my implementation of this example

* I have removed some of the manual configuration around the vpc in favor of using Terraforms ability to get the cidr blocks
* I have removed manual configuration of availability zones in favor or a data block that will check if the zone is available
* I have created the IAM role discussed above using Terraform (this can be viewed in the `iam.tf` file)
* I have removed the `runtime_platform` block from the `aws_ecs_task_definition` as this should only be required if using an image built on arm that is deployed to X86 architecture
* I have also standardized some of the resource names and am using variables so that the examples in this repo are very similar

## Quickstart

### Deploy

* `terraform init`
    * With multiple examples in this repo this should be run every time you change examples
* `terraform validate`
* `terraform plan`
* `terraform apply -auto-approve`

### Test

The DNS name of the resources will be returned as an output for testing purposes

### Destroy / Cleanup

* `terraform destroy -auto-approve`
## Things that are the same across examples

* `provider.tf` is exactly the same for example-1, example-gpt-1, example-gpt-2, example-gpt-3,
* `terraform.tf` is exactly the same for example-1, example-gpt-1, example-gpt-2, example-gpt-3,
* `utils.tf` is exactly the same for example-1, example-gpt-1, example-gpt-2, example-gpt-3,
* `data.tf` is exactly the same for example-1, example-gpt-1, example-gpt-2, example-gpt-3,
* `ecs.tf` is exactly the same for example-1, example-gpt-1, example-gpt-2, example-gpt-3,
* `iam.tf` is exactly the same for example-1, example-gpt-1, example-gpt-2, example-gpt-3,

## Things that are similar

* `vpc.tf` has the same configuration as example-gpt-1, but it also includes an additional subnet and mapping
* `security-group.tf` has the same configuration in example-1, example-gpt-1, example-gpt-2

## Things that are different

* example-1 and example-gpt-3 have much in common but are somewhat different; example-1 does not do dynamic port mapping
* includes `aws_ecs_capacity_provider` and `aws_ecs_cluster_capacity_providers`
* has additional configuration in `aws_ecs_service` block
* I have removed some of the manual configuration around the vpc in favor of using Terraforms ability to get the cidr blocks
* I have removed manual configuration of availability zones in favor or a data block that will check if the zone is available
* I have created the IAM role discussed above using Terraform (this can be viewed in the `iam.tf` file)
* I have removed the `runtime_platform` block from the `aws_ecs_task_definition` as this should only be required if using an image built on arm that is deployed to X86 architecture