#!bin/bash


terraform apply -auto-approve

sleep 30

terraform_output=$(terraform output --json) 

private_ip1=$(jq -re ".instance_private_ip_1.value" <<< "${terraform_output}")
private_ip2=$(jq -re ".instance_private_ip_2.value" <<< "${terraform_output}")

cd ansible
sed -i "s/seeds:.*/seeds: \"$private_ip1, $private_ip2\"/1" cassandra.yaml
ansible-playbook cassandra-playbook.yaml
