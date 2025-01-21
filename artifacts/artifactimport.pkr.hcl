variables:
  ARTIFACTORY_URL: "https://your-artifactory-url.com/artifactory"
  ARTIFACTORY_USER: "your-artifactory-user"
  ARTIFACTORY_PASSWORD: "your-artifactory-password"
  ARTIFACTORY_REPO: "libs-release-local"
  ARTIFACTORY_ARTIFACT: "my-app-1.0.jar"

packer_build_name: "my-ami"

builders:
  - type: amazon-ebs
    region: "us-east-1" 
    source_ami: "ami-xxxxxxxx" 
    instance_type: "t2.micro" 
    ssh_username: "ec2-user" 
    ami_name: "{{user `packer_build_name`}}"
    ami_description: "My Packer-built AMI"
    tags:
      Name: "{{user `packer_build_name`}}"

provisioners:
  - type: shell
    inline: |
      mkdir -p /opt/my-app
      curl -u "${ARTIFACTORY_USER}:${ARTIFACTORY_PASSWORD}" -L "${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/${ARTIFACTORY_ARTIFACT}" -o /opt/my-app/${ARTIFACTORY_ARTIFACT}
      # ... further provisioning steps (e.g., install dependencies, configure application)

post-processors:
  - type: amazon-ebs
    region: "{{user `region`}}"
    no_reboot: true