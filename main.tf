resource "aws_vpc" "infnet-lab" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = "infnet-lab"

    }
    }

locals {
  
  private_subnets_cidr = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
  public_subnets_cidr = ["10.0.2.0/24", "10.0.4.0/24", "10.0.6.0/24"]
}

data "aws_availability_zones" "available" {
    state = "available"
}
    resource "aws_subnet" "infnet-lab-private" {
        count = length(local.private_subnets_cidr)
        vpc_id = aws_vpc.infnet-lab.id
        cidr_block = local.private_subnets_cidr[count.index]
        availability_zone = data.aws_availability_zones.available.names[count.index]
        map_public_ip_on_launch = false
        tags = {
          Name = "private-${count.index}"

        }
    }

    resource "aws_subnet" "infnet-lab-public" {
        count = length(local.public_subnets_cidr)
        vpc_id = aws_vpc.infnet-lab.id
        cidr_block = local.public_subnets_cidr[count.index]
        availability_zone = data.aws_availability_zones.available.names[count.index]
        map_public_ip_on_launch = true
        tags = {
          Name = "public-${count.index}"
          
        }
    }

    resource "aws_internet_gateway" "infnet-lab-igw" {
        vpc_id = aws_vpc.infnet-lab.id
        tags = {
          Name = "infnet-lab-igw"
        }
             
    }
    resource "aws_route_table" "infnet-lab-public" {
        vpc_id = aws_vpc.infnet-lab.id
        tags = {
          Name = "infnet-lab-public-rt"
        }
    }
    resource "aws_route_table_association" "public_subnet_association" {
        count = length(local.public_subnets_cidr)
        subnet_id = aws_subnet.infnet-lab-public[count.index].id
        route_table_id = aws_route_table.infnet-lab-public.id
    }

    resource "aws_route" "infnet-lab-public" {
        route_table_id = aws_route_table.infnet-lab-public.id
        destination_cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.infnet-lab-igw.id
    }
    
      

