variable "region" {
  description = "The name of an AWS region"
  type        = string
}

variable "env" {
  description = "Resource environment tag (i.e. dev, stage, prod)"
  type        = string
  default     = "test"
}

variable "service" {
  description = "Resource service tag"
  type        = string
  default     = "egress-proxy"
}

variable "description" {
  description = "Resource description tag"
  type        = string
  default     = "Kong API Gateway"
}

variable "parent_domain" {

}

variable "vpc_name" {
  description = "VPC that resources should be deployed to"
  type        = string
}
variable "subnet_names" {
  description = "Subnets that resources should be deployed in"
  type        = list(string)
}

variable "container_image" {

}

variable "httpbin_host" {
  description = "(Optional) Hostname of httpbin to use in testing"
  default     = "httpbin.org"
}
