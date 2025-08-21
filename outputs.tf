# output "ec2_public_dnss" {
#     value = [
#         for ins in aws_instance.my_instance : ins.public_dns
#     ]
# }

# output "ec2_public_ip" {
#   value = [
#     for ins in aws_instance.my_instance : ins.public_ip
#   ]
# }