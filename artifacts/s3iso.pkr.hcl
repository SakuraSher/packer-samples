# Configure Packer variables
variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "ami_name" {
  type = string
  default = "my-golden-image-{{timestamp}}"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "s3_bucket" {
  type = string
  default = "my-bucket"
}

variable "image_key" {
  type = string
  default = "images/my-image.img"
}

variable "iso_key" {
  type = string
  default = "isos/my-iso.iso"
}

# Define the builder for creating an AMI
builder {
  type = "amazon-ebs"
  region = var.aws_region
  source_ami = "ami-xxxxxxxx" # Replace with your actual source AMI ID
  instance_type = var.instance_type
  ssh_username = "ubuntu"
  ami_name = var.ami_name
}

# Provisioners to prepare the instance
provisioner "shell" {
  inline = [
    "sudo mkdir -p /mnt",
    "sudo mount -o loop /dev/loop0 /mnt",
    "sudo aws s3 cp s3://${var.s3_bucket}/${var.image_key} /mnt/image.img",
    "sudo dd if=/mnt/image.img of=/dev/sda bs=1M status=progress",
    "sudo umount /mnt",
    "sudo losetup -d /dev/loop0",
    "sudo reboot"
  ]
}

provisioner "shell" {
  inline = [
    "sudo mkdir -p /media/iso",
    "sudo mount -o loop /dev/loop1 /media/iso",
    "sudo aws s3 cp s3://${var.s3_bucket}/${var.iso_key} /media/iso/install.iso",
    "sudo /media/iso/install/setup.sh" # Replace with your actual installation script path
    "sudo umount /media/iso",
    "sudo losetup -d /dev/loop1",
    "sudo reboot"
  ]
}

# Post-processor to register the built AMI
post-processor "amazon-ebs" {
  region = var.aws_region
}