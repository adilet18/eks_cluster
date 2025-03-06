#------------------------------------------------------------
# Generating Passwords and Storing them into ParameterStore
#------------------------------------------------------------


resource "random_password" "rds_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}


resource "aws_ssm_parameter" "rds_password" {
  name        = "/prod/mysql"
  description = "Password for MySQL"
  type        = "SecureString"
  value       = random_password.rds_password.result
}



#-------------------------------------------------------------------
#                    Creating RDS Database
#-------------------------------------------------------------------

resource "aws_db_instance" "rds" {
  identifier             = var.settings.database.identifier
  db_name                = var.settings.database.db_name
  allocated_storage      = var.settings.database.allocated_storage
  engine                 = "postgres"
  engine_version         = var.settings.database.engine_version
  instance_class         = var.settings.database.instance_class
  username               = var.settings.database.username
  password               = random_password.rds_password.result
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.id
  vpc_security_group_ids = [aws_security_group.db_security_group.id]
  publicly_accessible    = false
  skip_final_snapshot    = true
  apply_immediately      = true
  tags = {
    Name = "${var.env}-${var.settings.database.identifier}"
  }
}


resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "main_subnet_group"
  description = "The main group of subnets"
  subnet_ids  = var.private_subnet_cidrs_db
}
