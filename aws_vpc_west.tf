
//Create eu-west-1 VPC
resource "aws_vpc" "west" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

//Create IGW
resource "aws_internet_gateway" "west" {
  vpc_id = aws_vpc.west.id
}

//Route Table
resource "aws_route" "west-internet_access" {
  route_table_id         = aws_vpc.west.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.west.id
}

resource "aws_route" "west-peeraccess" {
  route_table_id            = aws_vpc.west.main_route_table_id
  destination_cidr_block    = "192.168.240.0/21"
  vpc_peering_connection_id = mongodbatlas_network_peering.aws-atlas-west.connection_id
  depends_on                = [aws_vpc_peering_connection_accepter.west-peer]
}

//Subnet-A
resource "aws_subnet" "west-az1" {
  vpc_id                  = aws_vpc.west.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1a"
}

//Subnet-B
resource "aws_subnet" "west-az2" {
  vpc_id                  = aws_vpc.west.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "eu-west-1b"
}

/*Security-Group
Ingress - Port 80 -- limited to instance
          Port 22 -- Open to ssh without limitations
Egress  - Open to All*/

resource "aws_security_group" "west_default" {
  name_prefix = "default-"
  description = "Default security group for all instances in ${aws_vpc.west.id}"
  vpc_id      = aws_vpc.west.id
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      aws_vpc.west.cidr_block,
    ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_peering_connection_accepter" "west-peer" {
  vpc_peering_connection_id = mongodbatlas_network_peering.aws-atlas-west.connection_id
  auto_accept               = true
}