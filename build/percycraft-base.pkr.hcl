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
  security_group_id = "sg-05c7965a1a755551c"
  ssh_timeout       = "20m"
  vpc_id            = "vpc-09c7f69f2900a0df4"
  subnet_id         = "subnet-0c53e3a5493659240"
}

build {
  name    = "percycraft-base"
  sources = ["source.amazon-ebs.percycraft-base"]
  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    script = "build/provision-base.sh"
  }
}
