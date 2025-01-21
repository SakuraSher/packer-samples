#packer configuration with ec2 image with Vault Integration 

variables "value_addr" {
    type = string
    default = "http://localhost:8200"
}

variables "valut_token" {
     type = string
     sensitive = true
 }

 variables "aws_region"{
    type = string
    sensitive = true
 }

 variables "    "