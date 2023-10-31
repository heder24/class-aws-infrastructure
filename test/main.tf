################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "app.terraform.io/heder24/project/aws/"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]


  private_subnet_names = ["Private Subnet One", "Private Subnet Two"]
  # public_subnet_names omitted to show default name generation for all three subnets
  database_subnet_names    = ["DB Subnet One"]
  elasticache_subnet_names = ["Elasticache Subnet One", "Elasticache Subnet Two"]
  redshift_subnet_names    = ["Redshift Subnet One", "Redshift Subnet Two", "Redshift Subnet Three"]
  intra_subnet_names       = []

  create_database_subnet_group  = false
  manage_default_network_acl    = false
  manage_default_route_table    = false
  manage_default_security_group = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true


  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60

  tags = local.tags
}

##################################### SG #####################################
