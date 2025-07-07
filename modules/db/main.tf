resource "aws_db_instance" "this" {
  engine                 = "postgres"
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  db_name                = var.DB_NAME
  username               = var.DB_USER
  password               = var.DB_PASSWORD
  port                   = var.DB_PORT
  publicly_accessible    = var.publicly_accessible
  skip_final_snapshot    = var.skip_final_snapshot
  vpc_security_group_ids = [aws_security_group.db_security_group.id]
  db_subnet_group_name   = var.aws_db_subnet_group_names
  tags = {
    Name = "${var.env}-db-instance"
    Env  = var.env
  }
}
resource "aws_security_group" "db_security_group" {
  
  vpc_id = var.vpc_id
  name   = "db_security_group"
  description = "Security group for the database"

  ingress {
    from_port   = var.DB_PORT
    to_port     = var.DB_PORT
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}