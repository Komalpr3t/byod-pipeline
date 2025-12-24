variable "env_name" {
  type = string
}

variable "key_name" {
  type    = string
  default = "my-key" # We will override this in tfvars
}

# 1. Get the latest Ubuntu AMI automatically
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# 2. Create Security Group to allow SSH (22) and Splunk (8000)
resource "aws_security_group" "splunk_sg" {
  name        = "splunk-sg-${var.env_name}"
  description = "Allow SSH and Splunk"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Create the Instance
resource "aws_instance" "splunk_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = var.key_name
  
  security_groups = [aws_security_group.splunk_sg.name]

  tags = {
    Name = "Splunk-Server-${var.env_name}"
  }
}

# 4. Outputs (Required for Task 1)
output "instance_ip" {
  value = aws_instance.splunk_server.public_ip
}

output "instance_id" {
  value = aws_instance.splunk_server.id
}