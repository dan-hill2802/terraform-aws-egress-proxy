//terraform {
//  required_version = "~> 0.12.0"
//
//}
//
//variable "assume_role" {
//  default = "ci"
//}
//
//provider "aws" {
//  version = "~> 2.62.0"
//  region  = var.region
//
//  assume_role {
//    role_arn = "arn:aws:iam::${local.account[local.environment]}:role/${var.assume_role}"
//  }
//}
//
//provider "aws" {
//  version = "~> 2.62.0"
//  region  = var.region
//  alias   = "management"
//
//  assume_role {
//    role_arn = "arn:aws:iam::${local.account["management"]}:role/${var.assume_role}"
//  }
//}
//
//provider "aws" {
//  version = "~> 2.62.0"
//  region  = var.region
//  alias   = "management_dns"
//
//  assume_role {
//    role_arn = "arn:aws:iam::${local.account["management"]}:role/${var.assume_role}"
//  }
//}
//
//// Get AWS Account ID for credentials in use
//data "aws_caller_identity" "current" {
//}
//
//data "aws_region" "current" {
//}
//
//data "aws_availability_zones" "available" {
//}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_availability_zones" "current" {}

terraform {
  required_version = ">= 0.14.0"

  required_providers {
    random = "~> 2.0"
    aws    = "~> 3.36.0"
  }
}
