output "public_ip" {
    value = module.jenkins.public_ip                                  ### this public_ip is from module development ###
}

output "private_ip" {
    value = module.jenkins.private_ip
}
