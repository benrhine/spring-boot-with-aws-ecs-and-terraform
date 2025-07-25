# Example 1 - Custom Spring Boot Application (EC2)

This example is based on Example 1, but I swap out the image for the custom built spring boot container from this repo.

## Things that are different in my implementation of this example

* I have removed some of the manual configuration around the vpc in favor of using Terraforms ability to get the cidr blocks
* I have removed manual configuration of availability zones in favor or a data block that will check if the zone is available
* I have created the IAM role discussed above using Terraform (this can be viewed in the `iam.tf` file)
* I have removed the `runtime_platform` block from the `aws_ecs_task_definition` as this should only be required if using an image built on arm that is deployed to X86 architecture
* I have also standardized some of the resource names and am using variables so that the examples in this repo are very similar

## Quickstart

### Pre-requisites: Build the Docker Container

* When wanting to use a local image, you need to configure a local docker repo. This can be done with the following ...
    * `docker run -d -p 5001:5000 --restart=always --name registry registry:2`
    * https://stackoverflow.com/questions/57167104/how-to-use-local-docker-image-in-kubernetes-via-kubectl
    * I HAD ISSUE WITH THIS. I WAS ABLE TO GET THE REGISTRY UP AND RUNNING AND PUSH TO IT, BUT I COULDN'T GET KUBERNETES TO
    * PULL CORRECTLY FROM IT SO I WENT WITH SETTING UP AN ACTUAL DOCKER ACCOUNT (See below).
* Build the docker image
    * `docker image build -t spring-boot-with-aws-ecs-and-terraform:1.0 .`
* Tag the docker image
    * `docker tag spring-boot-with-aws-ecs-and-terraform:1.0 localhost:5001/spring-boot-with-aws-ecs-and-terraform:1.0`
    * tagging should use the build image name for parameter 1 and the repo name for parameter 2
    * the repo name MUST be prepended with the `localhost:5001/`
* Push the docker image to the local repo
    * `docker push localhost:5001/spring-boot-with-aws-ecs-and-terraform:1.0`
    * If you're having errors, check this
        * https://stackoverflow.com/questions/48038969/an-image-does-not-exist-locally-with-the-tag-while-pushing-image-to-local-regis
* If you want to test run just the docker image you can use the following command
    * `docker run -p 8080:8080 spring-boot-with-aws-ecs-and-terraform:1.0 `

### OR (preferred)

* Set up a personal docker account and push to it
    * `docker buildx build --platform linux/amd64 -t spring-boot-with-aws-ecs-and-terraform .`
        * This took a minute to figure out that when building on newer Macs it is built for ARM by default and then will
        * not run when deployed to a linux platform. Thus, when building the image, we need to specify the platform to build for.
    * `docker tag spring-boot-with-aws-ecs-and-terraform rhineb/spring-boot-with-aws-ecs-and-terraform:latest`
    * `docker push rhineb/spring-boot-with-aws-ecs-and-terraform:latest`
    * YOU WILL NOT BE ABLE TO TEST THIS IMAGE LOCALLY IF YOU ARE ON A M-SERIES MAC AS THE IMAGE IS BUILT FOR A DIFFERENT ARCHITECTURE

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