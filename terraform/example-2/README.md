# Example 2 (FARGATE)

This example is based on [this](https://shrihariharidas73.medium.com/deploying-a-simple-web-application-to-aws-ecs-with-github-actions-and-terraform-dd57200baa50) tutorial.

This is a simple example of how to use ECS with FARGATE. This more or less works exactly the same as an ECS deploy to EC2
but there are less configuration options once deployed.

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
* `vpc.tf` is exactly the same for example-1, example-gpt-1, example-gpt-2, example-gpt-3,
* `security-group.tf` is exactly the same for example-1, example-gpt-1, example-gpt-2, example-gpt-3,

## Things that are similar

* 

## Things that are different

* `iam.tf` this uses a different role
* This is a fargate deployment