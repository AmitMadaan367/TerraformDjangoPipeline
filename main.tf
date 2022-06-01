resource "aws_vpc" "dev" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "dev-vpc"
  }
}

resource "aws_internet_gateway" "myInternetGateway" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.dev.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Dev-publicSubnet"
  }
}




resource "aws_route_table" "public" {
  vpc_id = aws_vpc.dev.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myInternetGateway.id
  }
  
  
  tags = {
    Name = "publicRouteTable"
  }
}



resource "aws_route_table_association" "forPublic" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}




resource "aws_security_group" "public" {
  name = "my-public-sg"
  description = "Public internet access"
  vpc_id = aws_vpc.dev.id
 
  tags = {
    Name        = "my-public-sg"
    Role        = "public"
    Project     = "cloudcasts.io"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}



resource "aws_security_group_rule" "public_in_http" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "public_in_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}




resource "aws_s3_bucket" "mycodepipeline2" {
  bucket = "my-terraform-first-bucket2"

  tags = {
    Name        = "My terraform bucket"
    Environment = "My-Dev"
  }

}


resource "aws_s3_bucket_versioning" "public_bucket_versioning" {
  bucket = aws_s3_bucket.mycodepipeline2.id 

  versioning_configuration {
    status =   "Enabled"
  }
}

resource "aws_s3_bucket_acl" "mycodepipeline_acl" {
  bucket = aws_s3_bucket.mycodepipeline2.id
  acl    = "private"
}



resource "aws_instance" "PublicMachine" {
  ami           = "ami-0eea504f45ef7a8f7"
  instance_type = "t2.micro"
  key_name               = "webApp"
  vpc_security_group_ids = [aws_security_group.public.id]
  subnet_id              = aws_subnet.public.id
  associate_public_ip_address = "true"

  iam_instance_profile =  "${aws_iam_instance_profile.ec2_profile.name}"

  user_data = <<EOF
#! /bin/bash
sudo apt update -y
sudo apt install ruby -y
sudo apt install wget
sudo wget https://aws-codedeploy-us-east-2.s3.us-east-2.amazonaws.com/latest/install
sudo chmod +x ./install
sudo ./install auto
sudo service codedeploy-agent status
sudo service codedeploy-agent start 
sudo service codedeploy-agent restart
EOF

  tags = {
    Name = "pub"
    Terraform   = "true"
    Environment = "public"
  }

}

