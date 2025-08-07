# -----------------------------
# S3 Buckets (Private + Versioning)
# -----------------------------
resource "aws_s3_bucket" "private_buckets" {
  count  = 4
  bucket = "tf-private-bucket-${count.index + 1}-${var.project_suffix}"

  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  count  = 4
  bucket = aws_s3_bucket.private_buckets[count.index].id

  versioning_configuration {
    status = "Enabled"
  }
}

# -----------------------------
# VPC
# -----------------------------
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

# -----------------------------
# Subnets (Main + Secondary for RDS)
# -----------------------------
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "main-subnet"
  }
}

resource "aws_subnet" "secondary" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "secondary-subnet"
  }
}

# -----------------------------
# Internet Gateway and Route Tables
# -----------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "main-route-table"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "secondary" {
  subnet_id      = aws_subnet.secondary.id
  route_table_id = aws_route_table.main.id
}

# -----------------------------
# Security Groups
# -----------------------------
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH access"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_security_group" "allow_mysql" {
  name        = "allow_mysql"
  description = "Allow MySQL access"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_mysql"
  }
}

# -----------------------------
# EC2 Instance
# -----------------------------
resource "aws_instance" "web" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.main.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "web-instance"
  }
}

# -----------------------------
# RDS Subnet Group
# -----------------------------
resource "aws_db_subnet_group" "main" {
  name       = "main-subnet-group"
  subnet_ids = [aws_subnet.main.id, aws_subnet.secondary.id]

  tags = {
    Name = "main-subnet-group"
  }
}

# -----------------------------
# RDS Instance (MySQL)
# -----------------------------
resource "aws_db_instance" "main" {
  identifier              = "rds-instance"
  allocated_storage       = 20
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  db_name                 = var.db_name
  username                = var.db_user
  password                = var.db_password
  skip_final_snapshot     = true
  publicly_accessible     = true
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.allow_mysql.id]

  tags = {
    Name = "rds-mysql"
  }
}
