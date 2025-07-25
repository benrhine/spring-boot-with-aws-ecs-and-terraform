# Example 2 - Custom Spring Boot Application (FARGATE)

This example is based on Example 2, but I swap out the image for the custom built spring boot container from this repo.

This is a simple example of how to use ECS with FARGATE. This more or less works exactly the same as an ECS deploy to EC2
but there are less configuration options once deployed.

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
* `vpc.tf` is exactly the same for example-1, example-gpt-1, example-gpt-2, example-gpt-3,
* `security-group.tf` is exactly the same for example-1, example-gpt-1, example-gpt-2, example-gpt-3,

## Things that are similar

*

## Things that are different

* `iam.tf` this uses a different role
* This is a fargate deployment