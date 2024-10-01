#!/usr/bin/env python3
import os
master_ip = os.getenv("MASTER_IP")  # Get the master IP from environment variable
worker_ips_str = os.getenv("WORKER_IPS")  # Get the worker IPs as a comma-separated string
if master_ip is None:
    raise ValueError("Master IP environment variable 'MASTER_IP' is not set.")
if worker_ips_str is None:
    worker_ips = []
else:
    worker_ips = worker_ips_str.split(",")  # Split the string into a list of IPs
# Define the path for the inventory file
inventory_path = "/root/ansible/inventory.ini"
# Write the inventory file content
with open(inventory_path, 'w') as inventory_file:
    # Write the master node details
    inventory_file.write("[master]\n")
    inventory_file.write(f"{master_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa\n\n")  # Adding master IP details
    # Write the worker nodes details
    inventory_file.write("[workers]\n")
    for ip in worker_ips:
        # Write each worker IP in the required format
        inventory_file.write(f"{ip.strip()} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa\n")
# Print a message indicating the inventory file has been generated
print(f"Inventory file generated at {inventory_path}")
