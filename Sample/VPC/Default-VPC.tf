# VPC
## VPC
resource "aws_default_vpc" "default" {
  tags = {
    Name = "<env>-vpc"
  }
}

## Route Table
resource "aws_default_route_table" "default_rt" {
  default_route_table_id = aws_default_vpc.default.default_route_table_id

  tags = {
    Name = "<env>-public-rt"
  }
  depends_on = [aws_default_vpc.default]
}

## Subnet 
resource "aws_default_subnet" "default_az1" {
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "<env>-public-a"
  }
  depends_on = [aws_default_vpc.default]
}


resource "aws_default_subnet" "default_az2" {
  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "<env>-public-b"
  }
  depends_on = [aws_default_vpc.default]
}


resource "aws_default_subnet" "default_az3" {
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "<env>-public-c"
  }
  depends_on = [aws_default_vpc.default]
}


resource "aws_default_subnet" "default_az4" {
  availability_zone = "ap-northeast-2d"

  tags = {
    Name = "<env>-public-d"
  }
  depends_on = [aws_default_vpc.default]
}

## Attach Private Subnet in Route Table
resource "aws_route_table_association" "default_az1" {
  subnet_id = aws_default_subnet.default_az1.id
  route_table_id = aws_default_route_table.default_rt.id
  depends_on = [aws_default_vpc.default]
}

resource "aws_route_table_association" "default_az2" {
  subnet_id = aws_default_subnet.default_az2.id
  route_table_id = aws_default_route_table.default_rt.id
  depends_on = [aws_default_vpc.default]
}

resource "aws_route_table_association" "default_az3" {
  subnet_id = aws_default_subnet.default_az3.id
  route_table_id = aws_default_route_table.default_rt.id
  depends_on = [aws_default_vpc.default]
}

resource "aws_route_table_association" "default_az4" {
  subnet_id = aws_default_subnet.default_az4.id
  route_table_id = aws_default_route_table.default_rt.id
  depends_on = [aws_default_vpc.default]
}

# Output
output "vpc" {
  value = aws_default_vpc.default.id
}

output "default-subnet-az1" {
  value = aws_default_subnet.default_az1.id
}

output "default-subnet-az2" {
  value = aws_default_subnet.default_az2.id
}

output "default-subnet-az3" {
  value = aws_default_subnet.default_az3.id
}

output "default-subnet-az4" {
  value = aws_default_subnet.default_az4.id
}


output "default-rt" {
  value = aws_default_route_table.default_rt.id
}