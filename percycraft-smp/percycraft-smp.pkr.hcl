packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.1"
      source  = "github.com/hashicorp/amazon"
    }
    git = {
      version = ">= 0.6.2"
      source  = "github.com/ethanmdavidson/git"
    }
  }
}

data "amazon-parameterstore" "ami-base" {
  name = "/percycraft/ami-latest/percycraft-base"
}

data "git-repository" "repository" {}

source "amazon-ebs" "percycraft-smp" {
  ami_name              = "percycraft-smp"
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
  sources = ["source.amazon-ebs.percycraft-smp"]

  provisioner "shell" {
    inline = ["git clone --single-branch --branch ${data.git-repository.repository.head} https://github.com/dgolbourn/percycraft.git /opt/percycraft"]
  }

  provisioner "shell" {
    execute_command = "sudo env {{ .Vars }} {{ .Path }}"
    script          = "percycraft-smp/provision.sh"
  }

  post-processor "manifest" {}

  post-processor "shell-local" {
    inline = [
      "AMI_ID=$(jq -r '.builds[-1].artifact_id' packer-manifest.json | cut -d ':' -f2)",
      "aws ssm put-parameter --name '/percycraft/ami-latest/percycraft-smp' --type 'String' --value $AMI_ID --overwrite"
    ]
  }
}
