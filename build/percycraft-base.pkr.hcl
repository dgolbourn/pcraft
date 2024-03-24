packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "percycraft-base" {
  ami_name          = "percycraft-base"
  instance_type     = "t3a.large"
  region            = "eu-west-2"
  source_ami        = "ami-0e58172bedd62916b"
  ssh_username      = "ec2-user"
  ssh_timeout       = "20m"
}

build {
  name    = "percycraft-base"
  sources = ["source.amazon-ebs.percycraft-base"]
  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    script = "sudo build/provision-base.sh"
  }
}
