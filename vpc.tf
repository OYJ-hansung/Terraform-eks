# create VPC
resource "aws_vpc" "GoormProject-VPC" {
  cidr_block = "172.20.0.0/16"
  tags = {
    Name = "GoormProject-VPC"
  }
}

# create subnet
resource "aws_subnet" "GoormProject-Public1" {
  vpc_id            = aws_vpc.GoormProject-VPC.id
  cidr_block        = "172.20.0.0/20"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "GoormProject-Public1"
  }
}

resource "aws_subnet" "GoormProject-Public2" {
  vpc_id            = aws_vpc.GoormProject-VPC.id
  cidr_block        = "172.20.16.0/20"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = true
  tags = {
    Name = "GoormProject-Public2"
  }
}

resource "aws_subnet" "GoormProject-Pravate1" {
  vpc_id            = aws_vpc.GoormProject-VPC.id
  cidr_block        = "172.20.32.0/20"
  availability_zone = "ap-northeast-2b"
  tags = {
    Name = "GoormProject-Private1"
  }
}

resource "aws_subnet" "GoormProject-Pravate2" {
  vpc_id            = aws_vpc.GoormProject-VPC.id
  cidr_block        = "172.20.48.0/20"
  availability_zone = "ap-northeast-2d"
  tags = {
    Name = "GoormProject-Private2"
  }
}

# create IGW
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.GoormProject-VPC.id
  tags = {
    Name = "GoormProject-VPC_IGW"
  }
}

# create route table
resource "aws_route_table" "GoormProject-VPC-Public-route" {
  vpc_id = aws_vpc.GoormProject-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    "Name" = "GoormProject-VPC-Public-route"
  }
}

# create route table association
# Subnet 과 Route table 을 연결
resource "aws_route_table_association" "GoormProject-VPC-Public-routing1" {
  route_table_id = aws_route_table.GoormProject-VPC-Public-route.id
  subnet_id      = aws_subnet.GoormProject-Public1.id
}

resource "aws_route_table_association" "GoormProject-VPC-Public-routing2" {
  route_table_id = aws_route_table.GoormProject-VPC-Public-route.id
  subnet_id      = aws_subnet.GoormProject-Public2.id
}

# create NAT GW
resource "aws_route_table" "GoormProject-VPC-Private-route" {
  vpc_id = aws_vpc.GoormProject-VPC.id
}

resource "aws_route_table_association" "GoormProject-VPC-Private-routing1" {
  route_table_id = aws_route_table.GoormProject-VPC-Private-route.id
  subnet_id      = aws_subnet.GoormProject-Pravate1.id
}

resource "aws_route_table_association" "GoormProject-VPC-Private-routing2" {
  route_table_id = aws_route_table.GoormProject-VPC-Private-route.id
  subnet_id      = aws_subnet.GoormProject-Pravate2.id
}
