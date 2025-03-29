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

###for nexus need to create keys #### remember pakka 


resource "aws_key_pair" "tools" {
  key_name   = "tools"
   #you can paste the public key directly like this
  #public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6ONJth+DzeXbU3oGATxjVmoRjPepdl7sBuPzzQT2Nc sivak@BOOK-I6CR3LQ85Q"
  public_key = file("~/.ssh/tools.pub")
  # ~ means windows home directory
}

module "nexus" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "nexus"

  instance_type          = "t3.medium"
  vpc_security_group_ids = ["sg-0ff5ebb7b4219f91a"]
  ami = data.aws_ami.nexus_ami_info.id
  subnet_id              = "subnet-0c9315ff1d0824b25"
  key_name = aws_key_pair.tools.key_name

  tags = merge(
    var.common_tags,
    {
     Terraform   = "true"
        Name = "nexus"  
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