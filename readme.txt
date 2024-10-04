
#terraform init
#terraform apply -auto-approve
#terraform destroy -auto-approve
#sleep 20
#ansible-playbook -i /root/ansible/inventory.ini hostnameupdate.yaml
#ansible-playbook -i /root/ansible/inventory.ini installk8.yaml
#ansible-playbook -i /root/ansible/inventory.ini cri_dockerd.yaml
#ansible-playbook -i /root/ansible/inventory.ini kubeini.yaml
#sleep 20
#ansible-playbook -i /root/ansible/inventory.ini installcalico.yaml
#ansible-playbook -i /root/ansible/inventory.ini joinnode.yaml
#sleep 50
#ansible-playbook -i /root/ansible/inventory.ini team4-k8-helm.yaml
#ansible-playbook -i /root/ansible/inventory.ini installargocd.yaml
ansible-playbook -i /root/ansible/inventory.ini deployapplication.yaml
