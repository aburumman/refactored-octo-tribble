/**
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.this.public_ip
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.this.id
}

**/

/**
output "bastion_ip" {
  //value = aws_eip.bastion.public_ip
  value = module.ec2.bastion_ip
}  
**/
