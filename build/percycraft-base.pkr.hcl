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
  source_ami    = "ami-0e58172bedd62916b"
  ssh_username  = "ec2-user"
  ssh_timeout   = "20m"
  force_deregister = "true"
  force_delete_snapshot = "true"
}


build {
  name    = "percycraft-base"
  sources = ["source.amazon-ebs.percycraft-base"]

  provisioner "shell" {
    environment_vars = [
      "FOO=hello world"
    ]
    execute_command = "sudo env {{ .Vars }} {{ .Path }}"
    script          = "build/provision-base.sh"
  }

  post-processor "manifest"{}

  post-processor "shell-local" {
    inline = [
      "AMI_ID=$(jq -r '.builds[-1].artifact_id' packer-manifest.json | cut -d ':' -f2)",
      "aws ssm put-parameter --name '/percycraft/ami-latest/base-x86_64' --type 'String' --value $AMI_ID --overwrite"
    ]
  }
}
