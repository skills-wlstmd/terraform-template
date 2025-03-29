provider "aws" {
  region = "ap-northeast-2"
}

variable "title" {
  type = string
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

output "dns_name" {
  value = aws_alb.main.dns_name
}