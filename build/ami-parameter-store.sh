#!/bin/bash -xe
AMI_ID=$(jq -r '.builds[-1].artifact_id' packer-manifest.json | cut -d ":" -f2)
echo $AMI_ID >&2
aws ssm put-parameter \
  --name "/percycraft/ami-latest/base-x86_64" \
  --type "String" \
  --value "$AMI_ID" \
  --overwrite
