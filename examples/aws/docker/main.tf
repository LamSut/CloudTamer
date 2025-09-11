###############################
### Terraform Configuration ###
###############################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.10.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
  backend "s3" {}
}

provider "aws" {
  alias  = "singapore"
  region = "ap-southeast-1"
}

data "aws_region" "region_a" {
  provider = aws.singapore
}


####################
### Module VPC A ###
####################

data "aws_availability_zones" "region_a_azs" {
  provider = aws.singapore
  state    = "available"
}

module "vpc" {
  source = "../../../tf-modules/aws/vpc/vpc-c"
  providers = {
    aws = aws.singapore
  }

  default_cidr   = var.default_cidr
  vpc_c_dst_cidr = var.vpc_c_cidr

  vpc_c_cidr                = var.vpc_c_cidr
  vpc_c_availability_zone_1 = data.aws_availability_zones.region_a_azs.names[0]
  vpc_c_availability_zone_2 = data.aws_availability_zones.region_a_azs.names[1]
  vpc_c_availability_zone_3 = data.aws_availability_zones.region_a_azs.names[2]
}


##################
### Module ECR ###
##################

data "aws_ecr_authorization_token" "token" {
  provider = aws.singapore
}

module "ecr" {
  source = "../../../tf-modules/aws/ecr"
  providers = {
    aws = aws.singapore
  }

  ecr_repo_names   = keys(var.docker_images)
  ecr_force_delete = var.ecr_force_delete
}


#####################
### Module Docker ###
#####################

provider "docker" {
  registry_auth {
    address  = data.aws_ecr_authorization_token.token.proxy_endpoint
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

resource "null_resource" "get_dockerfiles" {
  provisioner "local-exec" {
    command = var.get_dockerfiles_command
  }

  depends_on = [module.ecr]
}

module "docker" {
  source = "../../../tf-modules/others/docker"

  docker_images = var.docker_images
  repo_urls     = module.ecr.repo_urls

  depends_on = [null_resource.get_dockerfiles]
}


##################
### Module ALB ###
##################

module "alb" {
  source = "../../../tf-modules/aws/alb"
  providers = {
    aws = aws.singapore
  }

  vpc                = module.vpc.vpc
  public_subnet_ids  = values(module.vpc.public_subnets)
  private_subnet_ids = values(module.vpc.private_subnets)
  sg_http            = module.vpc.sg_http
  cluster_name       = var.cluster_name

  fe_port = var.fe_port
}


##################
### Module ECS ###
##################

data "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole"
}

module "ecs_network" {
  source = "../../../tf-modules/aws/ecs/network"
  providers = {
    aws = aws.singapore
  }

  cluster_name = var.cluster_name

  vpc     = module.vpc.vpc
  sg_http = module.vpc.sg_http

  fe_port = var.fe_port
  be_port = var.be_port

  depends_on = [module.vpc]
}

module "ecs_be" {
  source = "../../../tf-modules/aws/ecs/be"
  providers = {
    aws = aws.singapore
  }

  cluster            = module.ecs_network.cluster
  task_family        = var.task_family
  execution_role_arn = data.aws_iam_role.ecs_task_execution.arn
  task_role_arn      = data.aws_iam_role.ecs_task_execution.arn

  vpc                = module.vpc.vpc
  private_subnet_ids = values(module.vpc.private_subnets)
  sg_http            = module.vpc.sg_http
  sg_be              = module.ecs_network.sg_be

  be_count = var.be_count
  be_port  = var.be_port

  be_container_definitions = templatefile("${path.module}/be_container_definitions.json", {
    backend_image = module.docker.image_urls["backend"]
    db_host       = "nilhil"
    cache_host    = "nilhil"
    backend_host  = "localhost"
    task_family   = var.task_family
    region        = data.aws_region.region_a.region
  })

  depends_on = [module.alb]
}

module "ecs_fe" {
  source = "../../../tf-modules/aws/ecs/fe"
  providers = {
    aws = aws.singapore
  }

  cluster            = module.ecs_network.cluster
  task_family        = var.task_family
  execution_role_arn = data.aws_iam_role.ecs_task_execution.arn
  task_role_arn      = data.aws_iam_role.ecs_task_execution.arn

  vpc                = module.vpc.vpc
  private_subnet_ids = values(module.vpc.private_subnets)
  sg_http            = module.vpc.sg_http
  sg_fe              = module.ecs_network.sg_fe

  fe_count  = var.fe_count
  fe_port   = var.fe_port
  fe_tg_arn = module.alb.fe_tg_arn

  fe_container_definitions = templatefile("${path.module}/fe_container_definitions.json", {
    frontend_image = module.docker.image_urls["frontend"]
    backend_url    = module.ecs_be.be_service_dns
    task_family    = var.task_family
    region         = data.aws_region.region_a.region
  })

  depends_on = [module.ecs_be]
}
