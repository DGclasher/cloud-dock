locals {
  engine_map = {
    postgres = {
      engine         = "postgres"
      engine_version = "16.3"
      port           = 5432
      instance_class = "db.t3.micro"
      family         = "postgres16"
    }
    mysql = {
      engine         = "mysql"
      engine_version = "8.0.36"
      port           = 3306
      instance_class = "db.t3.micro"
      family         = "mysql8.0"
    }
  }

  db_config = local.engine_map[var.database_type]
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.name}-db-subnets"
  }
}

resource "aws_security_group" "this" {
  name        = "${var.name}-db-sg"
  description = "Allow database traffic from ECS tasks only"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Database access from ECS"
    protocol        = "tcp"
    from_port       = local.db_config.port
    to_port         = local.db_config.port
    security_groups = [var.ecs_security_group_id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-db-sg"
  }
}

resource "aws_db_instance" "this" {
  identifier              = "${var.name}-db"
  engine                  = local.db_config.engine
  engine_version          = local.db_config.engine_version
  instance_class          = local.db_config.instance_class
  allocated_storage       = 20
  storage_type            = "gp2"
  db_name                 = replace(lower(var.name), "-", "_")
  username                = var.username
  password                = var.password
  port                    = local.db_config.port
  publicly_accessible     = false
  skip_final_snapshot     = true
  deletion_protection     = false
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.this.id]
  backup_retention_period = 0
  apply_immediately       = true

  tags = {
    Name = "${var.name}-db"
  }
}
