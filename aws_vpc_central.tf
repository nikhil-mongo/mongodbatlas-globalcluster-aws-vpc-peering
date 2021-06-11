
//Create eu-central-1 VPC
resource "aws_vpc" "central" {
  provider             = aws.eucentral
  cidr_block           = "172.31.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

//Create IGW
resource "aws_internet_gateway" "central" {
  provider = aws.eucentral
  vpc_id   = aws_vpc.central.id
}

//Route Table
resource "aws_route" "central-internet_access" {
  provider               = aws.eucentral
  route_table_id         = aws_vpc.central.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.central.id
}

resource "aws_route" "central-peeraccess" {
  provider                  = aws.eucentral
  route_table_id            = aws_vpc.central.main_route_table_id
  destination_cidr_block    = var.atlas_vpc_cidr_2
  vpc_peering_connection_id = mongodbatlas_network_peering.aws-atlas-central.connection_id
  depends_on                = [aws_vpc_peering_connection_accepter.central-peer]
}

//Subnet-A
resource "aws_subnet" "central-az1" {
  provider                = aws.eucentral
  vpc_id                  = aws_vpc.central.id
  cidr_block              = "172.31.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1a"
}

//Subnet-B
resource "aws_subnet" "central-az2" {
  provider                = aws.eucentral
  vpc_id                  = aws_vpc.central.id
  cidr_block              = "172.31.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "eu-central-1b"
}

/*Security-Group
Ingress - Port 80 -- limited to instance
          Port 22 -- Open to ssh without limitations
Egress  - Open to All*/

resource "aws_security_group" "central_default" {
  provider    = aws.eucentral
  name_prefix = "default-"
  description = "Default security group for all instances in ${aws_vpc.central.id}"
  vpc_id      = aws_vpc.central.id
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      aws_vpc.central.cidr_block,
    ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_peering_connection_accepter" "central-peer" {
  provider                  = aws.eucentral
  vpc_peering_connection_id = mongodbatlas_network_peering.aws-atlas-central.connection_id
  auto_accept               = true
}
