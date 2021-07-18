#!bin/bash

dir_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
dir_path="${dir_path}"

terraform apply -auto-approve



#sleep 15


terraform_output=$(terraform output --json) 


public_ip1=$(jq -re ".instance_public_ip_1.value" <<< "${terraform_output}") 
public_ip2=$(jq -re ".instance_public_ip_2.value" <<< "${terraform_output}")
private_ip1=$(jq -re ".instance_private_ip_1.value" <<< "${terraform_output}")
private_ip2=$(jq -re ".instance_private_ip_2.value" <<< "${terraform_output}")



cd ansible
sed -i "s/seeds:.*/seeds: \"$private_ip1, $private_ip2\"/1" cassandra.yaml
ansible-playbook cassandra-playbook.yaml
