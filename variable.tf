variable "service" {
  default = "newbie"
}

variable "network" {
  default = "123.0"
}

variable "ec2_ami_id" {
  default = "ami-02a405b3302affc24" # Amazon Linux 2023 AMI
}

variable "ec2_key_name" {
  type = string
}

variable "client_ip_v4_address" {
  type = string
}
