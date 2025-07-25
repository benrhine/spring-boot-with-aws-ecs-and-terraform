
variable "environment" {
  description = "Environment (dev/staging/prod)"
  type        = string
  default     = "dev"
}

variable "namespace" {
  description = "Project namespace for tagging"
  type        = string
  default     = "brr"
}

variable "project_name" {
  description = "Project name to be used for tagging"
  type        = string
  default     = "ecs-gpt-example-1"
}

variable "service_name" {
  description = "ECS Service name"
  type        = string
  default     = "nginx-service"
}

variable "vpc_cidr_block" {
  description = "Project name to be used for tagging"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "Project name to be used for tagging"
  type        = number
  default     = 2
}
