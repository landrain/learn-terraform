output "instance_id" {
  value = module.nginx.id
}

output "private_ip_address" {
  value = module.nginx.private_ip
}

output "public_ip_address" {
  value = module.nginx.public_ip
}
