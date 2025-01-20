packer{
  required_plugins{
    docker = {
      version = ">=1.0.8"
      source = "github.com/hashicorp/docker"
    }
  }
}

variable "image"{
  default =  "ubuntu:jammy"
}

source "docker" "ubuntu"{
  image = "ubuntu:jammy"
  commit = true

}

source "docker" "ubuntu-focal"{
  image = "ubuntu:focal"
  commit = true

}

build  {
  name = "learn-packer"
  sources=[
    "source.docker.ubuntu",
    "source.docker.ubuntu-focal",
    
  ]

  post-processor "docker-tag"{
  repository = "learn-packer"
  tags = ["ubuntu-jammy"]
  only = ["docker.ubuntu"]
}

post-processor "docker-tag"{
  repository = "learn-packer"
  tags = ["ubuntu-focal"]
  only = ["docker.ubuntu-focal"]
}
}



