resource "aws_security_group" "example" {
  name_prefix = "rds-db"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [var.security_group]
  }
  # egress {
  #   from_port = 0
  #   to_port = 0
  #   protocol = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "trial_db_subnet_group"
  description = "DB subnet group for tutorial"
  # subnet_ids = [given_subnet_id[0]]
  # subnet_ids = var.given_subnet_id
  subnet_ids = [var.private_subnet[2],var.private_subnet[3]]
}

resource "aws_db_instance" "default" {
  allocated_storage    = var.storage
   name              = "mydb"
  engine               = var.engine_type
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = var.db_user_name
  password             = var.db_password
  publicly_accessible  = false
  skip_final_snapshot  = true
  multi_az = var.standby_rds
  vpc_security_group_ids = [aws_security_group.example.id]
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.id
}
