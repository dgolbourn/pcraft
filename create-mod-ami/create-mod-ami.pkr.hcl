packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "branch" {
  type =  string
}

variable "repository" {
  type =  string
}

data "amazon-parameterstore" "ami-base" {
  name = "/percycraft/ami-latest/percycraft-base-ami"
}

source "amazon-ebs" "create-mod-ami" {
  ami_name              = "create-mod-ami"
  instance_type         = "t3a.large"
  region                = "eu-west-2"
  source_ami            = "${data.amazon-parameterstore.ami-base.value}"
  ssh_username          = "ec2-user"
  ssh_timeout           = "20m"
  force_deregister      = "true"
  force_delete_snapshot = "true"
}

build {
  name    = "percycraft"
  sources = ["source.amazon-ebs.create-mod-ami"]

  provisioner "shell" {
    inline = [
      "sudo dnf -y install git",
      "git clone --single-branch --branch ${var.branch} ${var.repository} /tmp/percycraft/"
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo chmod +x /tmp/percycraft/create-mod-ami/provision.sh",
      "sudo /tmp/percycraft/create-mod-ami/provision.sh"
    ]
  }

  provisioner "shell" {
    inline = [
      "rm -rf /tmp/percycraft/"
    ]
  }

  post-processor "manifest" {}

  post-processor "shell-local" {
    inline = [
      "AMI_ID=$(jq -r '.builds[-1].artifact_id' packer-manifest.json | cut -d ':' -f2)",
      "aws ssm put-parameter --name '/percycraft/ami-latest/create-mod-ami' --type 'String' --value $AMI_ID --overwrite"
    ]
  }
}
