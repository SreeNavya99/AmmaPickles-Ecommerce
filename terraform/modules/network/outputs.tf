output "vpc_id" {
  value = aws_vpc.amma_pickles.id
}

output "public_subnet_ids" {
  value = {
    for key, subnet in aws_subnet.public :
    key => subnet.id
  }
}

output "private_app_subnet_ids" {
  value = {
    for key, subnet in aws_subnet.private_app :
    key => subnet.id
  }
}

output "private_db_subnet_ids" {
  value = {
    for key, subnet in aws_subnet.private_db :
    key => subnet.id
  }
}
