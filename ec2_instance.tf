
resource "aws_key_pair" "my_key" {
    key_name = "key_pair_terraform"
    public_key = file("terraform_key.pub")
}

resource "aws_default_vpc" "default" {
  
}

resource "aws_security_group" "my_sc_gp" {
    name = "allo ssh"
    description = "allowing all ssh traffic and all outbound traffic"
    vpc_id = aws_default_vpc.default.id
    # egress {
    #     to_port = 22
    #     from_port = 22
    #     protocol = -1
    #     cidr_blocks = [ "0.0.0.0/0" ]
    # }
    # ingress {

    #     to_port = 22
    #     from_port = 22
    #     protocol = "tcp"
    #     cidr_blocks = [ "0.0.0.0/0" ]
    # }
}

resource "aws_vpc_security_group_ingress_rule" "allo_ssh" {
  security_group_id = aws_security_group.my_sc_gp.id
#   cidr_ipv4 = aws_default_vpc.default.cidr_block
  cidr_ipv4 = "0.0.0.0/0" 
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
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
    instance_type = "t2.micro"
    associate_public_ip_address = true
    tags = {
        Name = "new_ec2_instance"
    }
    root_block_device {
        volume_size = 15
    }
    
}