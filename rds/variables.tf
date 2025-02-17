variable "aws_region" {
  default = "us-east-1"
}

variable "env" {
  type    = string
  default = "prod"
}

variable "settings" {
  description = "Settings for Database instance"
  type        = map(any)
  default = {
    "database" = {
      allocated_storage = 30
      identifier        = "rds-postgres"
      db_name           = "mydb"
      engine            = "postgres"
      engine_version    = "14.15"
      instance_class    = "db.t3.micro"
      username          = "db_admin"
    },
    "instance" = {
      count         = 1
      instance_type = "t3.micro"
    }
  }
}

variable "vpc_id" {}

variable "subnet_ids" {}

variable "my_ip" {
  default = "158.181.157.142/32"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs_db" {
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "common_tags" {}
