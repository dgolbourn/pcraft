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

source "amazon-ebs" "lobby-ami" {
  ami_name              = "lobby-ami"
  instance_type         = "t4g.nano"
  region                = "eu-west-2"
  source_ami            = "ami-07ea0a7a46980a2cd"
  ssh_username          = "ec2-user"
  ssh_timeout           = "20m"
  force_deregister      = "true"
  force_delete_snapshot = "true"
}

build {
  name    = "lobby-ami"
  sources = ["source.amazon-ebs.lobby-ami"]

  provisioner "shell" {
    inline = [
      "sudo dnf -y install git",
      "git clone --single-branch --branch ${var.branch} ${var.repository} /tmp/percycraft/"
    ]
  }

  provisioner "shell" {
    inline = [ 
      "sudo chmod +x /tmp/percycraft/lobby-ami/provision.sh",
      "sudo /tmp/percycraft/lobby-ami/provision.sh" 
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
      "aws ssm put-parameter --name '/percycraft/ami-latest/lobby-ami' --type 'String' --value $AMI_ID --overwrite"
    ]
  }
}
