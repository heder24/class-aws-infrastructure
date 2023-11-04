module "ec2" {
  source  = "app.terraform.io/heder24/ec2/aws"
  version = "1.0.0"
   name = var.juice
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro" # used to set core count below
  # availability_zone           = element(module.vpc.azs, 0)
  # subnet_id                   = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids      = [module.security-groups.security_group_id]
  associate_public_ip_address = true
  disable_api_stop            = false
  # key_name = var.key_name
  # iam_instance_profile= module.iam.iam_instance_profile_id
  # create_iam_instance_profile = false
  user_data_base64            = base64encode(file("user-data.sh"))
  user_data_replace_on_change = true
  tags = {
    Name = var.juice
  }
}

module "security-groups" {
  source  = "app.terraform.io/heder24/security-groups/aws"
  version = "1.0.0"

 name        = "juice-sg"
#   vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
   {
    description = "Allow HTTPS from public IPV4"
    from_port   = 443
    to_port     = 443
    protocol    = 6
    cidr_blocks = "0.0.0.0/0"
    
  },
   {
    description = "Allow HTTP from public IPV4"
    from_port   = 80
    to_port     = 80
    protocol    = 6
    cidr_blocks = "0.0.0.0/0"
    
  },

  ]

  ingress_with_ipv6_cidr_blocks = [
   {
    description      = "HTTPS from public IPV6"
    from_port        = 443
    to_port          = 443
    protocol         = 6
    ipv6_cidr_blocks = "::/0"
  },
   {
    description      = "HTTP from public IPV6"
    from_port        = 80
    to_port          = 80
    protocol         = 6
    ipv6_cidr_blocks = "::/0"
  },

  ]

  egress_with_cidr_blocks = [
   {
    description = "HTTPS to anywhere IPV4"
    from_port   = 443
    to_port     = 443
    protocol    = 6
    cidr_blocks = "0.0.0.0/0"
   },
    {
    description = "HTTP to anywhere IPV4"
    from_port   = 80
    to_port     = 80
    protocol    = 6
    cidr_blocks = "0.0.0.0/0"
   },
  ]

  egress_with_ipv6_cidr_blocks = [
 {
    description = "HTTP to anywhere IPV4"
    from_port   = 80
    to_port     = 80
    protocol    = 6
    ipv6_cidr_blocks = "::/0"
  },
 {
    description = "HTTPS to anywhere IPV4"
    from_port   = 443
    to_port     = 443
    protocol    = 6
    ipv6_cidr_blocks = "::/0"
  },

  ]

}

module "route53" {
 source  = "app.terraform.io/heder24/route53/aws"
  version = "1.0.0"
  zone_name= "hederdevops.com."
   records = [
    {
      name = var.juice-name
      full_name_override = true
      type = "A"
        
          records = [
            module.ec2.public_ip
          ]
      
      value =  module.ec2.public_ip
    },
   ]
}

output "web-address" {
  value = module.ec2.public_ip
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

output "ami_id" {

  value = data.aws_ami.ubuntu.id
}

# data "aws_route53_zone" "hederdevops" {
#   name         = "hederdevops.com."
  
# }
# output "zone_id" {

#   value = data.aws_route53_zone.id
# }