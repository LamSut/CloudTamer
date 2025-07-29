terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.a, aws.b]
    }
  }
}

resource "aws_vpc_peering_connection" "peer_a_b" {
  provider = aws.a
  # peer_owner_id = var.peer_owner_id // If VPC B is in a different account
  # auto_accept = true // Used for same-account peering; set to false for cross-account
  vpc_id      = var.vpc_a
  peer_vpc_id = var.vpc_b
  peer_region = coalesce(var.peer_region, "us-east-1")
  tags        = { Name = "VPC A peering VPC B" }
}

resource "aws_route" "vpc_a_to_b" {
  provider                  = aws.a
  route_table_id            = var.vpc_a_private_rt
  destination_cidr_block    = var.vpc_b_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_a_b.id
}

resource "aws_route" "vpc_b_to_a" {
  provider                  = aws.b
  route_table_id            = var.vpc_b_private_rt
  destination_cidr_block    = var.vpc_a_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_a_b.id
}
