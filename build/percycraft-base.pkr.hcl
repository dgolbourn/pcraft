packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "percycraft-base" {
  ami_name      = "percycraft-base"
  instance_type = "t3a.large"
  region        = "eu-west-2"
  source_ami_filter {
    filters = {
      name                = "al2023-ami-kernel-default-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username = "ec2-user"
}

build {
  name    = "percycraft"
  sources = ["source.amazon-ebs.percycraft-base"]
  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    script = "build/provision-base.sh"
  }
}
