terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.a, aws.b]
    }
  }
}

##############################
### VPC Peering Connection ###
##############################

resource "aws_vpc_peering_connection" "peer_a_b" {
  provider = aws.a
  # peer_owner_id = var.peer_owner_id // If VPC B is in a different account
  vpc_id      = var.vpc_a
  peer_vpc_id = var.vpc_b
  peer_region = coalesce(var.peer_region, "us-east-1")
  tags        = { Name = "VPC A peering VPC B" }
}

resource "aws_vpc_peering_connection_accepter" "accept_peer_a_b" {
  provider                  = aws.b
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_a_b.id
  auto_accept               = true
  tags                      = { Name = "VPC B accepts VPC A peering" }
}


###############
### Routing ###
###############

resource "aws_route" "public_a_to_b" {
  provider                  = aws.a
  route_table_id            = var.vpc_a_public_rt
  destination_cidr_block    = var.vpc_b_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_a_b.id
}

resource "aws_route" "public_b_to_a" {
  provider                  = aws.b
  route_table_id            = var.vpc_b_public_rt
  destination_cidr_block    = var.vpc_a_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_a_b.id
}

resource "aws_route" "private_a_to_b" {
  provider                  = aws.a
  count                     = length(var.vpc_a_private_rt)
  route_table_id            = var.vpc_a_private_rt[count.index]
  destination_cidr_block    = var.vpc_b_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_a_b.id
}

resource "aws_route" "private_b_to_a" {
  provider                  = aws.b
  count                     = length(var.vpc_b_private_rt)
  route_table_id            = var.vpc_b_private_rt[count.index]
  destination_cidr_block    = var.vpc_a_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_a_b.id
}


#######################
### Peering Options ###
#######################

resource "aws_vpc_peering_connection_options" "peer_req_opts" {
  provider                  = aws.a
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_a_b.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [aws_vpc_peering_connection_accepter.accept_peer_a_b]
}

resource "aws_vpc_peering_connection_options" "peer_acc_opts" {
  provider                  = aws.b
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_a_b.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [aws_vpc_peering_connection_accepter.accept_peer_a_b]
}

