# Provider Configuration
provider "aws" {
  region = "us-east-1"
}
# SSH Key Pair Configuration
resource "aws_key_pair" "project_key" {
  key_name   = var.key_name
  public_key = file("/root/.ssh/id_rsa.pub")
}
# EC2 Instance for Kubernetes Master Node
resource "aws_instance" "k8s_master" {
  ami                    = var.ami_id
  instance_type         = var.instance_type
  key_name              = var.key_name
  subnet_id             = "subnet-092556102611df373"
  associate_public_ip_address = true
  root_block_device {
    volume_size = 20 # Set disk size to 20 GB
  }
  tags = {
    Name = "my-project-k8s-master"
  }
  user_data = <<-EOF
              #!/bin/bash
              # Disable swap
              swapoff -a
              sed -i '/ swap / s/^/#/' /etc/fstab
              EOF
}
# EC2 Instances for Kubernetes Worker Nodes
resource "aws_instance" "k8s_worker" {
  count                  = 3
  ami                    = var.ami_id
  instance_type         = var.instance_type
  subnet_id             = "subnet-092556102611df373"
  key_name               = var.key_name
  associate_public_ip_address = true
  root_block_device {
    volume_size = 20 # Set disk size to 20 GB
  }
  tags = {
    Name = "my-project-k8s-worker-${count.index + 1}"
  }
}
# Output the public IPs and names of the Kubernetes instances
output "k8s_master_info" {
  value = {
    name      = aws_instance.k8s_master.tags["Name"]
    public_ip = aws_instance.k8s_master.public_ip
  }
  description = "Kubernetes master instance name and public IP"
}
output "k8s_worker_info" {
  value = [
    for instance in aws_instance.k8s_worker : {
      name      = instance.tags["Name"]
      public_ip = instance.public_ip
    }
  ]
  description = "Kubernetes worker instances names and public IPs"
}
# Output the private IPs of the Kubernetes instances
output "k8s_master_private_ip" {
  value       = aws_instance.k8s_master.private_ip
  description = "Private IP address of the Kubernetes master instance"
}
output "k8s_worker_private_ips" {
  value       = aws_instance.k8s_worker[*].private_ip
  description = "Private IP addresses of the Kubernetes worker instances"
}
# Use local-exec to run a Python script to generate the inventory file
resource "null_resource" "generate_inventory" {
  provisioner "local-exec" {
    environment = {
      MASTER_IP  = aws_instance.k8s_master.private_ip
      WORKER_IPS = join(",", aws_instance.k8s_worker[*].private_ip)
    }
    command = "python3 /root/ansible/create_inventory.py"
  }
  # Ensure it runs after the instances are created
  depends_on = [aws_instance.k8s_master, aws_instance.k8s_worker]
}
