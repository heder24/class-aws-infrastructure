module "vpc" {
  source  = "app.terraform.io/heder24/vpc/aws"
  version = "1.0.0" 
}

module "acm" {
  source  = "app.terraform.io/heder24/acm/aws"
  version = "1.0.0"
}

module "alb" {
  source  = "app.terraform.io/heder24/alb/aws"
  version = "1.0.0"
}

module "autoscaling" {
  source  = "app.terraform.io/heder24/autoscaling/aws"
  version = "1.0.0"
  name = "asg"
}

module "ec2" {
  source  = "app.terraform.io/heder24/ec2/aws"
  version = "1.0.0"
}

module "iam" {
  source  = "app.terraform.io/heder24/iam/aws"
  version = "1.0.0"
}

module "security-groups" {
  source  = "app.terraform.io/heder24/security-groups/aws"
  version = "1.0.0"
}

