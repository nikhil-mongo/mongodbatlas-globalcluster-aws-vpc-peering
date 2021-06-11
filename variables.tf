variable "public_key" {
  description = "Public API key to authenticate to Atlas"
}
variable "private_key" {
  description = "Private API key to authenticate to Atlas"
}
variable "mongodbversion" {
  description = "The Major MongoDB Version"
  default     = "4.2"
}
variable "project_id" {
  description = "The Atlas Project Name"
}
variable "access_key" {
  description = "The access key for AWS Account"
}
variable "secret_key" {
  description = "The secret key for AWS Account"
}
variable "aws_account_id" {
  description = "My AWS Account ID"
}
variable "atlas_vpc_cidr_1" {
  default     = "192.168.240.0/21"
  description = "Atlas CIDR"
}
variable "atlas_vpc_cidr_2" {
  description = "Atlas CIDR"
  default     = "192.168.232.0/21"
}
