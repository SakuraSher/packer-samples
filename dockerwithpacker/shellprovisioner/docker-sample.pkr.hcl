packer{
    required_plugins{
        docker={
            source = "github.com/hashicorp/docker"
            version = ">=1.0.8"
        }
    }
}

source "docker" "ubuntu"{
    image = "ubuntu:jammy"
    commit = true
}

build {
    name = "learn-packer"
    sources = [
        "source.docker.ubuntu"
    ]
}