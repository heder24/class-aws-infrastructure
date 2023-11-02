################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "app.terraform.io/heder24/vpc/aws"
}
module "public_sg" {
  source = "app.terraform.io/heder24/security-groups/aws"
}
module "private_sg" {
  source = "app.terraform.io/heder24/security-groups/aws"
}
module "bastion_sg" {
  source = "app.terraform.io/heder24/security-groups/aws"
}
  

###################################### IAM #################################

module "base-ec2-role" {
  source = "app.terraform.io/heder24/iam/aws"
}

module "ec2-code-deploy" {
  source = "app.terraform.io/heder24/iam/aws"
}

########################################
#IAM SNS policy
########################################
module "iam_policy" {
  source ="app.terraform.io/heder24/iam/aws"
}


########################################### ACM ##############################################

locals {
  # Use existing (via data source) or create new zone (will fail validation, if zone is not reachable)
  #use_existing_route53_zone = true

}

module "acm" {
  source ="app.terraform.io/heder24/acm/aws"
}

############################### Route53 Records #############################

module "dns_records" {
  source = "app.terraform.io/heder24/route53/aws"

}

############################################ ALB ##############################################

##################################################################
# Application Load Balancer
##################################################################

module "alb" {
  source = "app.terraform.io/heder24/alb/aws"

}

################################################################################
# EC2 Module
################################################################################

module "prod_bastion" {
  source = "app.terraform.io/heder24/ec2/aws"

 
}



