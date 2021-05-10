module "vpc" {
  count                                    = var.create_vpc ? 1 : 0

  source                                   = "terraform-aws-modules/vpc/aws"
  version                                  = "2.78.0"
  region                                   = var.region

  name                                     = join(".", [var.vpc_name, local.environment])
  cidr                                     = var.cidr.vpc

  azs             = local.zone_names
  private_subnets = var.cidr.private
  public_subnets  = var.cidr.public

  enable_nat_gateway = true
  create_igw         = true

//  gateway_vpce_route_table_ids             = aws_route_table.proxy.*.id
//  interface_vpce_source_security_group_ids = [aws_security_group.internet_proxy.id]
//  interface_vpce_subnet_ids                = aws_subnet.proxy.*.id

  enable_ecr_api_endpoint        = true
  enable_ecr_dkr_endpoint        = true
  enable_ec2_endpoint            = true
  enable_ec2messages_endpoint    = true
  enable_ssm_endpoint            = true
  enable_ssmmessages_endpoint    = true
  enable_s3_endpoint             = true
  enable_public_s3_endpoint      = true
  enable_monitoring_endpoint     = true
  enable_logs_endpoint           = true

//  aws_vpce_services = [
//    "ecr.dkr",
//    "ecr.api",
//    "ec2",
//    "ec2messages",
//    "ssm",
//    "ssmmessages",
//    "s3",
//    "monitoring",
//    "logs"
//  ]

  tags = {
    Terraform   = "true"
    Environment = local.environment
  }
}
//
//resource "aws_internet_gateway" "igw" {
//  vpc_id = module.vpc.vpc.id
//}
//
//resource "aws_route_table" "public" {
//  vpc_id = module.vpc.vpc.id
//
//  tags = merge(
//    local.common_tags,
//    { Name = "internet-public" },
//  )
//}
//
//resource "aws_route" "internet" {
//  route_table_id         = aws_route_table.public.id
//  destination_cidr_block = "0.0.0.0/0"
//  gateway_id             = aws_internet_gateway.igw.id
//}
//
//resource "aws_subnet" "public" {
//  count             = length(data.aws_availability_zones.available.names)
//  cidr_block        = cidrsubnet(module.vpc.vpc.cidr_block, 3, count.index + 4)
//  availability_zone = data.aws_availability_zones.available.names[count.index]
//  vpc_id            = module.vpc.vpc.id
//
//  tags = merge(
//    local.common_tags,
//    { Name = "internet-public" },
//  )
//}
//
//resource "aws_route_table_association" "public" {
//  count          = length(data.aws_availability_zones.available.names)
//  subnet_id      = aws_subnet.public.*.id[count.index]
//  route_table_id = aws_route_table.public.id
//}
//
//resource "aws_eip" "nat" {
//  count      = length(data.aws_availability_zones.available.names)
//  vpc        = true
//  depends_on = [aws_internet_gateway.igw]
//}
//
//resource "aws_nat_gateway" "ngw" {
//  count         = length(data.aws_availability_zones.available.names)
//  allocation_id = aws_eip.nat.*.id[count.index]
//  subnet_id     = aws_subnet.public.*.id[count.index]
//  tags = merge(
//    local.common_tags,
//    { Name = "internet-egress-${aws_subnet.public.*.availability_zone[count.index]}" }
//  )
//}
//
//resource "aws_route_table" "proxy" {
//  count  = length(data.aws_availability_zones.available.names)
//  vpc_id = module.vpc.vpc.id
//
//  tags = merge(
//    local.common_tags,
//    { Name = "internet-proxy" },
//  )
//}
//
//resource "aws_route" "nat" {
//  count                  = length(data.aws_availability_zones.available.names)
//  route_table_id         = aws_route_table.proxy.*.id[count.index]
//  destination_cidr_block = "0.0.0.0/0"
//  nat_gateway_id         = aws_nat_gateway.ngw.*.id[count.index]
//}
//
//resource "aws_subnet" "proxy" {
//  count             = length(data.aws_availability_zones.available.names)
//  cidr_block        = cidrsubnet(module.vpc.vpc.cidr_block, 3, count.index)
//  availability_zone = data.aws_availability_zones.available.names[count.index]
//  vpc_id            = module.vpc.vpc.id
//
//  tags = merge(
//    local.common_tags,
//    { Name = "internet-proxy" },
//  )
//}
//
//resource "aws_route_table_association" "proxy" {
//  count          = length(data.aws_availability_zones.available.names)
//  subnet_id      = aws_subnet.proxy.*.id[count.index]
//  route_table_id = aws_route_table.proxy.*.id[count.index]
//}

resource "aws_security_group" "internet_proxy_endpoint" {
  name        = "egress_proxy_vpc_endpoint"
  description = "Control access to the Egress Proxy VPC Endpoint"
  vpc_id      = module.vpc.vpc_id

  tags = merge(
    local.common_tags,
    { Name = "egress-proxy-endpoint" }
  )
}

resource "aws_vpc_endpoint" "internet_proxy" {
  vpc_id              = module.vpc.vpc_id
  service_name        = aws_vpc_endpoint_service.internet_proxy.service_name
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.internet_proxy_endpoint.id]
  subnet_ids          = local.vpc.private_subnets
  private_dns_enabled = false

  tags = merge(
    local.common_tags,
    { Name = "internet-proxy" }
  )
}

data "aws_vpc" "vpc" {
  count = !var.create_vpc ? 1 : 0
  id    = var.vpc_id
}

locals {
  vpc = var.create_vpc ? {
    vpc_id                      = module.vpc[0].vpc_id
    private_subnets             = module.vpc[0].private_subnets
    private_subnets_cidr_blocks = module.vpc[0].private_subnets_cidr_blocks
    public_subnets              = module.vpc[0].public_subnets
    vpc_endpoint_s3_pl_id       = module.vpc[0].vpc_endpoint_s3_pl_id
    vpc_endpoint_dynamodb_pl_id = module.vpc[0].vpc_endpoint_dynamodb_pl_id
  } : {
    vpc_id                      = data.aws_vpc.vpc[0].id
    private_subnets             = var.private_subnets.ids
    private_subnets_cidr_blocks = var.private_subnets.cidr_blocks
    public_subnets              = var.public_subnets.ids
    vpc_endpoint_s3_pl_id       = ""
    vpc_endpoint_dynamodb_pl_id = ""
  }
}