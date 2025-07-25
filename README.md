# spring-boot-with-aws-ecs-and-terraform
Example SpringBoot application deployed with Terraform and Docker to ECS (EC2 and Fargate examples)

This project contains multiple examples with a number of variations on how things can be deployed to ECS. It
is set up similarly to [spring-boot-with-aws-eks-and-terraform](https://github.com/benrhine/spring-boot-with-aws-eks-and-terraform)
except in this case, I am leveraging ECS instead of EKS. I have also refactored common portions of the Terraform config
into separate files so make it easier to see the differences.

All examples that are not deploying the custom SpringBoot image will be deploying a nginx container.

Getting ECS up and working proved to be more challenging than expected, and for that reason there are more variations in
the examples included in this repo. I tried 3 different tutorials, all of which were well written, and not a single one
resulted in a working example without some additional modifications. 

* [Example 1](https://spacelift.io/blog/terraform-ecs)
* [Example 2](https://shrihariharidas73.medium.com/deploying-a-simple-web-application-to-aws-ecs-with-github-actions-and-terraform-dd57200baa50)
* [Example 3](https://www.gyden.io/en/content-hub/a-comprehensive-guide-for-amazon-ecs-ec-2-using-terraform)

At this point, I threw the examples into AI and asked them to help me identify the differences. ChatGPT helped me build
three quick working examples to help us understand, and I think this is the place to start from in order to gain a solid
understanding.

* [Gpt Example 1](https://chatgpt.com/share/687e7852-dc74-8011-82b8-734c45946ce3)
* [Gpt Example 2](https://chatgpt.com/share/687e7852-dc74-8011-82b8-734c45946ce3)
* [Gpt Example 3](https://chatgpt.com/share/687e7852-dc74-8011-82b8-734c45946ce3)

**Note**
All examples contain their own README to attempt to not overwhelm the reader with too much documentation. This top 
level README is intended to summarize everything that is in this repository.

**CAUTION**
Again, as stated at the start many resources that were determined to be the same between all these examples have been
pulled out into their own `.tf` files. Stated another way ALL EXAMPLES require these files, BUT YOU ARE NOT REQUIRED TO
TOUCH THEM. For some examples, some additional resources that are not used may be declared for simplicity (subnet-b is
only used in gpt-3 and example-1 but is available in all examples)

**WARNING!!! _Before you start ..._ I don't understand why but example-1, example-1-custom-spring-boot-ec2, and example-gpt-3 will not clean up correctly unless you go into the AWS Console ->
EC2 -> Scroll to the bottom -> Auto scale groups -> delete auto-scale group. I do not get this as it is extremely
similar to example-1 and example-1 does not have this problem.**

## How to deploy all examples

* `terraform init`
* `terraform validate`
* `terraform plan`
* `terraform apply -auto-approve`

**Note: When switching between examples always re `terraform init`**

## How to destroy all examples

* `terraform destroy -auto-approve`

*AGAIN WARNING!!! I don't understand why but example-1, example-1-custom-spring-boot-ec2, and example-gpt-3 will not clean up correctly unless you go into the AWS Console ->
EC2 -> Scroll to the bottom -> Auto scale groups -> delete auto-scale group. I do not get this as it is extremely 
similar to example-1 and example-1 does not have this problem.*

## Gpt Example 1 - Network bridge mode (EC2)

Note: Original, un-edited version of the `tf` from the tutorial can be found in the `main-gpt-1-original.tf` file

## Gpt Example 2 - Network bridge mode (EC2)

Note: Original, un-edited version of the `tf` from the tutorial can be found in the `main-gpt-2-original.tf` file

## Gpt Example 3 - Network bridge mode (EC2)

Note: Original, un-edited version of the `tf` from the tutorial can be found in the `main-gpt-3-original.tf` file

## Example 1 - Network awsvpc mode (EC2)

Note: Original, un-edited version of the `tf` from the tutorial can be found in the `main-example-1.tf.bak` file

## Example 2 - Network awsvpc mode  (Fargate)

Note: Original, un-edited version of the `tf` from the tutorial can be found in the `main-example-2.tf.bak` file

## Example 3 - Network awsvpc mode (EC2)

*WARNING!!! I did not ever get this example fully working*

Note: Original, un-edited version of the `tf` from the tutorial can be found in the `main-example-3.tf.bak` file

## Pre-requisites: Example 1 Custom or Example 2 Custom

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

## Example 1 Custom (EC2)

Will deploy the custom spring boot application from this repo which will contain a rest endpoint that is accessible through postman.

## Example 2 Custom (Fargate)

Will deploy the custom spring boot application from this repo which will contain a rest endpoint that is accessible through postman.


## EC2

EC2 is the primary compute layer behind ECS; while it is more managed than using EKS, it still grants a medium level of
control to the end user. It also has far more manual control than deploying using Fargate. If at any point you think you
may want manual control of your low level resources, or you want to better manage cost, setting up your ECS to use EC2
would probably be the better choice for you.


## Fargate

Fargate is a serverless compute engine for containers (similar to lambda), primarily used with Amazon ECS. It automatically manages your 
infrastructure, allowing you to focus on deploying and scaling containerized applications. Fargate is ideal for long-running 
applications, microservices, or batch processing—where you need fine-grained control over resource allocation (CPU, memory) 
and want to avoid managing underlying servers.

If you do not have the expertise or resources for the deeper management required for EC2 and cost is a trade-off that
is acceptable, then using Fargate to back your ECS is probably the correct choice as it lowers the management bar and will
allow you to focus on the application development more than managing the infrastructure.

It is also possible to do container deployments to lambda but if you are looking at ECS, Fargate, or EKS, it is assumed 
you already have a base understanding of the differences between Fargate and Lambda.

- https://docs.aws.amazon.com/decision-guides/latest/fargate-or-lambda/fargate-or-lambda.html

## ECS Equivalents at other Cloud Providers

- The Azure equivalent of AWS's Elastic Container Service (ECS) is Azure Container Instances (ACI)
- The Azure equivalent of AWS's Elastic Kubernetes Service (EKS) is Azure Kubernetes Instances (AKS)
- GCP does not seem to have a direct equivalent of AWS's Elastic Container Service (ECS); Similar would be Cloud Run but that seems to be more comparable to Fargate by itself
- The GCP equivalent of AWS's Elastic Kubernetes Service (EKS) is Google Kubernetes Engine (GKE)

## Use Terraform to estimate cost of current stack (Infracost)

- https://spacelift.io/blog/terraform-cost-estimation-using-infracost


## Reference

https://stackoverflow.com/questions/74582083/aws-ecs-how-to-list-fargate-containers
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html
https://www.google.com/search?client=safari&rls=en&q=where+to+see+aws+fargate+containers&ie=UTF-8&oe=UTF-8
https://www.google.com/search?client=safari&rls=en&q=terraform+deploy+to+ecs&ie=UTF-8&oe=UTF-8
https://www.google.com/search?q=ec2+ecs+with+terraform+2025&client=safari&sca_esv=0e39c597175f10a4&rls=en&sxsrf=AE3TifOAL-IGEe5k5ijaGEzqFWfJIJRvCA%3A1752681180890&ei=3Mp3aJeTNpnikPIPse34kAI&ved=0ahUKEwiX8cOZ3sGOAxUZMUQIHbE2HiIQ4dUDCBA&uact=5&oq=ec2+ecs+with+terraform+2025&gs_lp=Egxnd3Mtd2l6LXNlcnAiG2VjMiBlY3Mgd2l0aCB0ZXJyYWZvcm0gMjAyNTIIEAAYgAQYogQyCBAAGIAEGKIEMggQABiiBBiJBUiNF1DXBVjVDHABeAGQAQCYAXCgAaMDqgEDMS4zuAEDyAEA-AEBmAIFoAK9A8ICChAAGLADGNYEGEfCAgcQIxiwAhgnwgIFEAAY7wWYAwCIBgGQBgiSBwMyLjOgB8wNsgcDMS4zuAe0A8IHBTAuMS40yAcU&sclient=gws-wiz-serp
https://www.gyden.io/en/content-hub/a-comprehensive-guide-for-amazon-ecs-ec-2-using-terraform
https://medium.com/@mike_tyson_cloud/how-to-deploy-an-aws-ecs-cluster-with-terraform-020632b89413
https://www.reddit.com/r/aws/comments/qs4nxk/is_fargate_just_a_part_of_ecs/

### Fargate variant
https://judoscale.com/blog/terraform-on-amazon-ecs
https://medium.com/@21harsh12/deploy-a-docker-container-with-aws-ecs-and-terraform-ee0a27f1f5a6
https://earthly.dev/blog/deploy-dockcontainers-to-awsecs-using-terraform/
https://medium.com/@neamulkabiremon/build-a-production-grade-aws-ecs-fargate-cluster-with-terraform-modular-scalable-ci-cd-ready-07b0c5d40e6f#
https://shrihariharidas73.medium.com/deploying-a-simple-web-application-to-aws-ecs-with-github-actions-and-terraform-dd57200baa50

### Stuck on pending
https://repost.aws/questions/QUTXu194SMQECvCbrICGHvMA/ecs-task-always-stuck-at-pending-with-no-logs
https://repost.aws/knowledge-center/ecs-tasks-stuck-pending-state
https://repost.aws/questions/QUWhT9ezJIRmWXKPOlJDi5dg/ecs-task-stuck-in-the-provisioning-state
https://stackoverflow.com/questions/63123466/all-tasks-on-an-ecs-service-stuck-in-provisioning-state
https://www.reddit.com/r/aws/comments/17yvdio/task_stuck_in_provisioning_state/




