packer {
  required_plugins {
    docker = {
      version = ">=1.0.8"
      source  = "github.com/hashicorp/docker"

    }
  }
}

source "docker" "ubuntu" {
  image  = "ubuntu:jammy"
  commit = true
}

build {
  name = "learn"
  sources = [
    "source.docker.ubuntu"
  ]


provisioner "shell" {
    environment_vars = [
        "FOO=hello world"
    ]
    inline = [
        "echo Adding files to docker container",
        "echo \"FOO is $FOO\" > example.txt", 
    ]
}
}