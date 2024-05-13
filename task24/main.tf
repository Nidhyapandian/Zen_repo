provider "aws" {
  region = "ap-south-1"
}

# Create a VPC
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy= "default"
  tags = {
    Name = "vpc-deploy"
    }
}
# Create a public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "myvpc-public-subnet"
  }
}
# Create a private subnet
resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "myvpc-private-subnet"
  }
}
# create an internet gateway
resource "aws_internet_gateway" "terraform_ig" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "myvpc-internet-gateway"
  }
}
# create a public route table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_ig.id
  }

  tags = {
    Name = "myvpc-public-rt"
  }
}
# create an association between public subnet with public route table
resource "aws_route_table_association" "pubasso" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-rt.id
}
# create a elastic ip
resource "aws_eip" "my-eip" {
}
# create a NAT gateway
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.my-eip.id
  subnet_id     = aws_subnet.public-subnet.id

  tags = {
    Name = "gw NAT"
  }
}  
# create a private route table
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "myvpc-private-rt"
  }
}
# create an association between private subnet with private route table
resource "aws_route_table_association" "priasso" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-rt.id
}
# create a security group
resource "aws_security_group" "my-sg" {
    name = "my-sg"
    vpc_id = aws_vpc.myvpc.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
   
 ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "myvpc-sg"

    }

}
# create an ec2 jumpbox 
resource "aws_instance" "jumpbox" {
    ami = "ami-05e00961530ae1b55"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.my-sg.id]
    subnet_id = aws_subnet.public-subnet.id
    associate_public_ip_address = true
    user_data =  <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y nginx
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF


 tags = {
    Name = "Jumpbox"
  }

}
# create an ec2 intance
resource "aws_instance" "ec2" {
    ami = "ami-05e00961530ae1b55"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.my-sg.id]
    subnet_id = aws_subnet.private-subnet.id
    tags = {
    Name = "Instance2"
  }

}