data "aws_route53_zone" "public" {
  name         = local.hosted_zone
  private_zone = false
}
