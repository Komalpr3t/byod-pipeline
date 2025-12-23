variable "env_name" {
  type = string
}

resource "null_resource" "test" {
  provisioner "local-exec" {
    command = "echo Terraform is running in ${var.env_name}"
  }
}

#v2.0