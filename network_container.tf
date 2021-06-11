resource "mongodbatlas_network_container" "atlas_container_west" {
  atlas_cidr_block = var.atlas_vpc_cidr_1
  project_id       = var.project_id
  provider_name    = "AWS"
  region_name      = "EU_WEST_1"
}

data "mongodbatlas_network_container" "atlas_container_west" {
  container_id = mongodbatlas_network_container.atlas_container_west.container_id
  project_id   = var.project_id
}

resource "mongodbatlas_network_peering" "aws-atlas-west" {
  accepter_region_name   = "eu-west-1"
  project_id             = var.project_id
  container_id           = mongodbatlas_network_container.atlas_container_west.container_id
  provider_name          = "AWS"
  route_table_cidr_block = aws_vpc.west.cidr_block
  vpc_id                 = aws_vpc.west.id
  aws_account_id         = var.aws_account_id
}
resource "mongodbatlas_network_container" "atlas_container_central" {
  atlas_cidr_block = var.atlas_vpc_cidr_2
  project_id       = var.project_id
  provider_name    = "AWS"
  region_name      = "EU_CENTRAL_1"
}

data "mongodbatlas_network_container" "atlas_container_central" {
  container_id = mongodbatlas_network_container.atlas_container_central.container_id
  project_id   = var.project_id
}

resource "mongodbatlas_network_peering" "aws-atlas-central" {
  accepter_region_name   = "eu-central-1"
  project_id             = var.project_id
  container_id           = mongodbatlas_network_container.atlas_container_central.container_id
  provider_name          = "AWS"
  route_table_cidr_block = aws_vpc.central.cidr_block
  vpc_id                 = aws_vpc.central.id
  aws_account_id         = var.aws_account_id
}