output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.this.id
}

output "second_subnet" {
  description = ""
  value       = aws_subnet.second.id
}

output "third_subnet" {
  description = ""
  value       = aws_subnet.third.id
}

output "fourth_subnet" {
  description = ""
  value       = aws_subnet.fourth.id
}

output "this_subnet" {
  description = ""
  value       = aws_subnet.this.id
}



output "internet_gateway" {
  value = aws_internet_gateway.this
}