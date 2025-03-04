module "jenkins" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins"

  instance_type          = "t3.small"
  vpc_security_group_ids = ["sg-0ff5ebb7b4219f91a"]
  ami = data.aws_ami.ami_info.id
  subnet_id              = "subnet-0c9315ff1d0824b25"
  user_data = file("jenkins.sh")

  tags = merge(
    var.common_tags,
    {
        Terraform   = "true"
        Name = "jenkins"  
    }
  )
}


module "jenkins-agent" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins-agent"

  instance_type          = "t3.small"
  vpc_security_group_ids = ["sg-0ff5ebb7b4219f91a"]
  ami = data.aws_ami.ami_info.id
  subnet_id              = "subnet-0c9315ff1d0824b25"
  user_data = file("jenkins-agent.sh")

  tags = merge(
    var.common_tags,
    {
        Terraform   = "true"
        Name = "jenkins-agent"  
    }
  )
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 3.0"

  zone_name = var.zone_name

  records = [
    {
      name    = "jenkins"
      type    = "A"
      ttl = 1
      records = [
        module.jenkins.public_ip,
      ]
      allow_overwrite = true
    },
    {
      name    = "jenkins-agent"
      type    = "A"
      ttl     = 1
      records = [
        module.jenkins-agent.private_ip,
      ]
     allow_overwrite = true 
    },
  ] 
}