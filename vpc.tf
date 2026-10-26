resource "aws_vpc" "private_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "private-vpc"
  }

  
}

resource "aws_subnet" "private_subnet" {
  count = 2
  vpc_id = aws_vpc.private_vpc.id
  cidr_block = cidrsubnet(aws_vpc.private_vpc.cidr_block, 8, count.index + 1)

  tags = {
    Name = "private_subnet-${count.index +1}"
  }

  
  
}

data "aws_ami" "ec2_instances" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
    
  
  
}

resource "aws_instance" "servers" {
  count = 2
  
  ami = data.aws_ami.ec2_instances.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private_subnet[count.index].id 
  lifecycle {
    prevent_destroy = true
    ignore_changes = all
      
    }
    tags = {
      Name = "server-${count.index + 1}"
    }
    
  }
  

  
