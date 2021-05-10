//data "aws_secretsmanager_secret_version" "internet_egress" {
//  secret_id = "/internet-egress"
//}

locals {
  name        = var.project_name
  environment = terraform.workspace == "default" ? "mgmt-dev" : terraform.workspace
  hosted_zone = join(".", [local.environment, var.root_domain])
  account     = data.aws_caller_identity.current.account_id

  zone_count = length(data.aws_availability_zones.current.zone_ids)
  zone_names = data.aws_availability_zones.current.names

  common_tags = {
    Environment = local.environment
    Application = local.name
    Terraform   = "true"
    Owner       = var.project_owner
    Team        = var.project_team
  }

  squid_config_s3_main_prefix = "egress-proxy"

  ecs_squid_config_s3_main_prefix = "container-egress-proxy"

  squid_conf_filename = "squid.conf"

  cw_agent_namespace                                    = "/app/internet_proxy"
  cw_agent_log_group_name                               = "/app/internet_proxy"
  cw_agent_metrics_collection_interval                  = 60
  cw_agent_cpu_metrics_collection_interval              = 60
  cw_agent_disk_measurement_metrics_collection_interval = 60
  cw_agent_disk_io_metrics_collection_interval          = 60
  cw_agent_mem_metrics_collection_interval              = 60
  cw_agent_netstat_metrics_collection_interval          = 60

  asg_ssmenabled = {
    management-dev = "True"
    management     = "False"
  }

  env_prefix = {
    development    = "dev."
    qa             = "qa."
    stage          = "stg."
    integration    = "int."
    preprod        = "pre."
    production     = ""
    management-dev = "mgt-dev."
    management     = "mgt."
  }

//  dw_domain = "${local.env_prefix[local.environment]}${var.root_domain}"

  whitelist_names = {
    ci_cd        = "whitelist_ci_cd"
    packer       = "whitelist_packer"
    aws_services = "whitelist_aws_services"
  }

  whitelists = ["ci_cd"]

}
