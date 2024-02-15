
module "db" {
  source = "terraform-aws-modules/rds/aws"
  version = "6.4.0"

  identifier = lower("${var.project_name}-db")

  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = var.db_instance_class
  allocated_storage = 5

  auto_minor_version_upgrade = false

  db_name  = replace("${var.project_name}", "-", "_")
  username = var.db_user
  port     = "3306"
  password = "test1234" # This is a default password, please change it

  create_db_option_group = false

  backup_retention_period  = 7
  delete_automated_backups = false

  manage_master_user_password = false

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring
  monitoring_interval    = "30"
  monitoring_role_name   = "MyRDSMonitoringRole-${var.project_name}-${var.env}"
  create_monitoring_role = true

  publicly_accessible = false

  vpc_security_group_ids = [aws_security_group.rds.id]

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = var.private_subnets

  multi_az = true

  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"

  # Database Deletion Protection 
  deletion_protection = false
  skip_final_snapshot = false

  # kms key
  # kms_key_id = aws_kms_key.rds_key.arn

}

resource "aws_security_group" "rds" {
  name        = "rds"
  description = "Allow inbound traffic on port 3306"
  vpc_id      = var.vpc_id

  ingress {
    description      = "MySQL access from within VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    ipv6_cidr_blocks = [var.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "rds"
  }
}