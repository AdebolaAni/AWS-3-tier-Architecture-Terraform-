# This is to create a vpc named patty_moore
resource "aws_vpc" "patty_moore_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "patty_moore_vpc"
  }
}

# This code is to create an internet gateway named patty_moore_IGW
resource "aws_internet_gateway" "patty_moore_igw" {
  vpc_id = aws_vpc.patty_moore_vpc.id

  tags = {
    Name = "patty_moore_IGW"
  }
}

#This code is to create a public subnet in az1a
resource "aws_subnet" "patty_moore_public_subnet_az1a" {
  vpc_id                  = aws_vpc.patty_moore_vpc.id
  cidr_block              = var.public_subnet_az1a_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  depends_on = [aws_vpc.patty_moore_vpc,
  aws_internet_gateway.patty_moore_igw]

  tags = {
    Name = "patty_moore_public_subnet_az1a"
  }
}

#This code is to create a public subnet in az1b
resource "aws_subnet" "patty_moore_public_subnet_az1b" {
  vpc_id                  = aws_vpc.patty_moore_vpc.id
  cidr_block              = var.public_subnet_az1b_cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  depends_on = [aws_vpc.patty_moore_vpc,
  aws_internet_gateway.patty_moore_igw]

  tags = {
    Name = "patty_moore_public_subnet_az1b"
  }
}

#This code is to create a private-app subnet in az1a
resource "aws_subnet" "patty_moore_private_app_subnet_az1a" {
  vpc_id                  = aws_vpc.patty_moore_vpc.id
  cidr_block              = var.private_app_az1a_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  depends_on = [aws_vpc.patty_moore_vpc,
  aws_internet_gateway.patty_moore_igw]

  tags = {
    Name = "patty_moore_private_app_subnet_az1a"
  }
}

#This code is to create a private_app subnet in az1b
resource "aws_subnet" "patty_moore_private_app_subnet_az1b" {
  vpc_id                  = aws_vpc.patty_moore_vpc.id
  cidr_block              = var.private_app_az1b_cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  depends_on = [aws_vpc.patty_moore_vpc,
  aws_internet_gateway.patty_moore_igw]

  tags = {
    Name = "patty_moore_private_app_subnet_az1b"
  }
}

#Next is to create a private_data subnet in az1a
resource "aws_subnet" "patty_moore_private_data_subnet_az1a" {
  vpc_id                  = aws_vpc.patty_moore_vpc.id
  cidr_block              = var.private_data_az1a_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  depends_on = [aws_vpc.patty_moore_vpc,
  aws_internet_gateway.patty_moore_igw]

  tags = {
    Name = "patty_moore_private_data_subnet_az1a"
  }
}

#Finally, create a private_data subnet in az1b
resource "aws_subnet" "patty_moore_private_data_subnet_az1b" {
  vpc_id                  = aws_vpc.patty_moore_vpc.id
  cidr_block              = var.private_data_az1b_cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  depends_on = [aws_vpc.patty_moore_vpc,
  aws_internet_gateway.patty_moore_igw]

  tags = {
    Name = "patty_moore_private_data_subnet_az1b"
  }
}

#This is to create an elastic IP for the NAT gateway
resource "aws_eip" "patty_moore_eip_for_nat_gateway" {
  domain = "vpc"

  tags = {
    Name = "patty_moore_eip_for_nat_gateway"
  }
}

#Next is to create a Nat-gateway
resource "aws_nat_gateway" "patty_moore_nat_gateway" {
  allocation_id = aws_eip.patty_moore_eip_for_nat_gateway.id
  subnet_id     = aws_subnet.patty_moore_public_subnet_az1a.id

  tags = {
    Name = "patty_moore_nat_gateway"
  }
  depends_on = [aws_internet_gateway.patty_moore_igw,
  aws_subnet.patty_moore_public_subnet_az1a]
}

#Now, we go ahead and create a public route table
resource "aws_route_table" "patty_moore_public_rt" {
  vpc_id = aws_vpc.patty_moore_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.patty_moore_igw.id
  }
  tags = {
    Name = "patty_moore_public_rt"
  }

}
#Next, we associate the public rt with the public subnet in az1a
resource "aws_route_table_association" "public_subnet_association_az1a" {
  subnet_id      = aws_subnet.patty_moore_public_subnet_az1a.id
  route_table_id = aws_route_table.patty_moore_public_rt.id
}

#We now assoicate the public rt with the public subnet in az1b
resource "aws_route_table_association" "public_subnet_association_az1b" {
  subnet_id      = aws_subnet.patty_moore_public_subnet_az1b.id
  route_table_id = aws_route_table.patty_moore_public_rt.id
}

#Next item on the list is to create a private app route table for the private subnets
resource "aws_route_table" "patty_moore_private_app_rt" {
  vpc_id = aws_vpc.patty_moore_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.patty_moore_nat_gateway.id
  }
  tags = {
    Name = "patty_moore_private_app_rt"
  }

}

#We associate the private-app-rt with the private-app subnet in az1a
resource "aws_route_table_association" "private_app_subnet_association_az1a" {
  subnet_id      = aws_subnet.patty_moore_private_app_subnet_az1a.id
  route_table_id = aws_route_table.patty_moore_private_app_rt.id
}

#We associate the private-rt with the private-app subnet in az1b
resource "aws_route_table_association" "private_app_subnet_association_az1b" {
  subnet_id      = aws_subnet.patty_moore_private_app_subnet_az1b.id
  route_table_id = aws_route_table.patty_moore_private_app_rt.id
}

#Next item on the list is to create a private data route table for the private subnets
resource "aws_route_table" "patty_moore_private_data_rt" {
  vpc_id = aws_vpc.patty_moore_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.patty_moore_nat_gateway.id
  }
  tags = {
    Name = "patty_moore_private_data_rt"
  }

}

#We associate the private-rt with the private-data subnet in az1a
resource "aws_route_table_association" "private_data_subnet_association_az1a" {
  subnet_id      = aws_subnet.patty_moore_private_data_subnet_az1a.id
  route_table_id = aws_route_table.patty_moore_private_data_rt.id
}

#Next we associate the private-rt with the private-data subnet in az1b
resource "aws_route_table_association" "private_data_subnet_association_az1b" {
  subnet_id      = aws_subnet.patty_moore_private_data_subnet_az1b.id
  route_table_id = aws_route_table.patty_moore_private_data_rt.id
}
