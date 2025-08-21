
resource "aws_key_pair" "my_key" {
    key_name = "key_pair_terraform"
    public_key = file("terraform_key.pub")
}


resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "my_personal_vpc"
  }
}

resource "aws_subnet" "my_main" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  # region = "us-east-1"
  availability_zone = "us-east-1b"
  tags = {
    Name= "main-1"
  }
}

resource "aws_subnet" "my_main_2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.10.0/24"
  # region = "us-east-2"
  availability_zone = "us-east-1c"
  tags = {
    Name= "main-2"
  }
}

resource "aws_route_table" "test" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = aws_vpc.main.cidr_block
    gateway_id = "local"
  }
  # route {
  #   cidr_block = "0.0.0.0/0"
  #   gateway_id = "igw-066f917f633254dbf"
  # }
}

resource "aws_security_group" "my_sc_gp" {
    name = "test_group"
    description = "allowing all ssh traffic and all outbound traffic"
    vpc_id = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "allo_ssh" {
  security_group_id = aws_security_group.my_sc_gp.id
#   cidr_ipv4 = aws_default_vpc.default.cidr_block
  cidr_ipv4 = "0.0.0.0/0" 
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.my_sc_gp.id
  ip_protocol = "tcp"
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 8000
  to_port = 8000
}

resource "aws_vpc_security_group_egress_rule" "allow_outbound" {
    ip_protocol = "-1"
    cidr_ipv4 = "0.0.0.0/0"
    security_group_id = aws_security_group.my_sc_gp.id
}

resource "aws_instance" "my_instance" {

    vpc_security_group_ids = [aws_security_group.my_sc_gp.id]
    key_name = aws_key_pair.my_key.key_name
    ami = "ami-020cba7c55df1f615"
    instance_type = var.enviroment == var.prod ? var.prod : "t2.micro"
    associate_public_ip_address = true
    tags = {
        Name = var.enviroment == var.prod ? "aws_medium_instance_prac" : "aws_micro_instance_prac"
    }
    
    root_block_device {
        volume_size = 15
    }
    
}


# ?we can use terraform import to import any instance which is manaully create to this
# resource "aws_instance" "my_new_instance" {
#   ami = "unknown"
#   instance_type = "unknown"
# }