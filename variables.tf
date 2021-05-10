variable "region" {
  default = ""
}

variable "project_name" {
  description = "The project / repo name for use in resource naming / tags"
  type        = string
  default     = "egress-proxy"
}

variable "project_owner" {
  description = "The name of the project owner, for use in tagging"
  type        = string
  default     = "OPS"
}

variable "project_team" {
  description = "The name of the project team, for use in tagging"
  type        = string
  default     = "OPS"
}

variable "root_domain" {
  description = "The root domain for use with the deployment Route53 records"
  type        = string
  default     = "ROOT_DOMAIN_NOT_SET"
}

variable "ami_id" {
  description = "AMI ID to use for launching Concourse Instances"
  type        = string
  default     = "ami-098828924dc89ea4a" // latest AL2 x86 AMI as of 15/02/21
}

variable "proxy_conf" {
  description = "Squid proxy config options"

  type = object({
    port = number
  })

  default = ({
    port = 3128
  })
}

variable "cidr" {
  description = "The CIDR ranges used for the deployed subnets"

  type = object({
    vpc     = string
    private = list(string)
    public  = list(string)
  })

  default = {
    vpc     = "10.0.0.0/16"
    private = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
    public  = ["10.0.100.0/24", "10.0.101.0/24", "10.0.102.0/24"]
  }
}

variable "vpc_name" {
  description = "The name to use for the VPC"
  type        = string
  default     = "egress-proxy"
}

variable "create_vpc" {
  description = "(Optional) Flag to indicate if new VPC needs to be created."
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "(Optional) The id of the VPC to create resources in. Requires `create_vpc` to be `false`."
  type        = string
  default     = null
}

variable "public_subnets" {
  description = "(Optional) List of public subnet IDs and CIDRs."
  type = object({
    ids         = list(string)
    cidr_blocks = list(string)
  })
  default = {
    ids         = []
    cidr_blocks = []
  }
}

variable "private_subnets" {
  description = "(Optional) List of private subnet IDs and CIDRs."
  type = object({
    ids         = list(string)
    cidr_blocks = list(string)
  })
  default = {
    ids         = []
    cidr_blocks = []
  }
}

variable "create_ecs_cluster" {
  description = "(Optional) Flag to indicate if new ECS Cluster needs to be created."
  type        = bool
  default     = true
}

variable "ecs_cluster_id" {
  description = "(Optional) The id of the ECS Cluster to target for ECS resources. Requires `create_ecs_cluster` to be `false`."
  type        = string
  default     = null
}
