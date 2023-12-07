#creating VPC
resource "aws_vpc" "main" {
    cidr_block    = var.vpc_cidr
    tags          = {
        "Name"    = "myterraformvpc"
     } 
} 
#creating public and private subnet
resource "aws_subnet" "public_subnet1" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.public_subnet1
    map_public_ip_on_launch = true
    availability_zone       = var.az[0]
  tags = {
    "Name" = "public_subnet1"
  }
  
}
resource "aws_subnet" "public_subnet2" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.public_subnet2
    map_public_ip_on_launch = true
    availability_zone       = var.az[1]
  tags = {
    "Name" = "public_subnet2"
  }
  
}
resource "aws_subnet" "private_subnet1" {
    vpc_id              = aws_vpc.main.id
    cidr_block          = var.private_subnet1
    availability_zone   = var.az[0]
  tags = {
    "Name" = "private_subnet1"
  }
}
resource "aws_subnet" "private_subnet2" {
    vpc_id              = aws_vpc.main.id
    cidr_block          = var.private_subnet2
    availability_zone   = var.az[1]
  tags = {
    "Name" = "private_subnet2"
  }
}
resource "aws_subnet" "private_subnet3" {
    vpc_id              = aws_vpc.main.id
    cidr_block          = var.private_subnet3
    availability_zone   = var.az[0]
  tags = {
    "Name" = "private_subnet3"
  }
}
resource "aws_subnet" "private_subnet4" {
    vpc_id              = aws_vpc.main.id
    cidr_block          = var.private_subnet4
    availability_zone   = var.az[1]
  tags = {
    "Name" = "private_subnet4"
  }
}

#creating Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "myterraformigw"
  }
}
#creating a route table for public subnet
resource "aws_route_table" "publicrt" {
    vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id

  }
  tags = {
    "Name" = "public_rt"
  }
}
#creating a public subnet route table association
resource "aws_route_table_association" "publicRTA1" {
    subnet_id = aws_subnet.public_subnet1.id
    route_table_id = aws_route_table.publicrt.id
  
}
resource "aws_route_table_association" "publicRTA2" {
    subnet_id = aws_subnet.public_subnet2.id
    route_table_id = aws_route_table.publicrt.id
  
}
#creating a elastic ip for Natgateway
resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet1.id
  depends_on    = [aws_internet_gateway.igw]
}

#creating a route table for private subnet
resource "aws_route_table" "privatert" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private_rt"
  }
}

#creating a private subnet route table association
resource "aws_route_table_association" "privateRTA1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.privatert.id
}
resource "aws_route_table_association" "privateRTA2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.privatert.id
}
resource "aws_route_table_association" "privateRTA3" {
  subnet_id      = aws_subnet.private_subnet3.id
  route_table_id = aws_route_table.privatert.id
}
resource "aws_route_table_association" "privateRTA4" {
  subnet_id      = aws_subnet.private_subnet4.id
  route_table_id = aws_route_table.privatert.id
}
