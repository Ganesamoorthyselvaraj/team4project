# File: variables.tf
# Variable for instance type
variable "instance_type" {
  description = "Type of EC2 instance for Kubernetes and OpenShift nodes"
  type        = string
  default     = "t2.medium"  # Default instance type
}
# Variable for the AMI ID
variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default     = "ami-0e86e20dae9224db8"  # Ubuntu 20.04 AMI
}
# Variable for the AWS key name
variable "key_name" {
  description = "Name of the key pair to use for the EC2 instances"
  type        = string
  default     = "project-key"  # Default key name
}
