resource "aws_db_subnet_group" "postgres_subnet_group" {
  name       = "postgres-subnet-group-2"  # renamed to avoid conflict
  subnet_ids = [var.private_subnet_a_id, var.private_subnet_b_id]

  tags = {
    Name = "PostgreSQL Subnet Group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier              = "postgres-db"
  engine                  = "postgres"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.postgres_subnet_group.name
  vpc_security_group_ids  = [var.postgres_sg_id]
  skip_final_snapshot     = true
  publicly_accessible     = false

  tags = {
    Name = "PostgreSQL-Instance"
  }
}

resource "aws_db_instance" "mysql" {
  identifier              = "mysql-db"
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.postgres_subnet_group.name
  vpc_security_group_ids  = [var.mysql_sg_id]
  skip_final_snapshot     = true
  publicly_accessible     = false

  tags = {
    Name = "MySQL-Instance"
  }
}
