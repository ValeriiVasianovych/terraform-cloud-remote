output "aws_ami_id" {
  value = data.aws_ami.latest_ubuntu.id
}

output "aws_region" {
  value = data.aws_region.current.name
}

output "instance_ip" {
  value = aws_instance.web-server.public_ip
}

output "instance_az" {
  value = aws_instance.web-server.availability_zone
}

output "instance_id" {
  value = aws_instance.web-server.id
}

