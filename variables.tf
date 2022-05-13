variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/24"
}
variable "private_subnet_cidrs" {
  default = ["10.0.0.0/27", "10.0.0.32/27"]
  type = list(string)
}
variable "public_subnet_cidrs" {
  default = ["10.0.0.64/27", "10.0.0.96/27"]
  type = list(string)
}
variable "vpc_name" {
  type = string
  default = "customer_vpc"
}
variable "region" {
  type = string
  default = "us-east-1"
}

variable "role_name" {
  type = string
  default ="role_assume_by_terraform"
}

variable "account_id" {
  type=string
}