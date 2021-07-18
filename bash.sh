#!bin/bash

dir_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
dir_path="${dir_path}"

#terraform



#sleep 15


terraform_output=$(terraform output --json) 


public_ip1=$(jq -re ".instance_public_ip_1.value" <<< "${terraform_output}") 
public_ip2=$(jq -re ".instance_public_ip_2.value" <<< "${terraform_output}")
private_ip1=$(jq -re ".instance_private_ip_1.value" <<< "${terraform_output}")
private_ip2=$(jq -re ".instance_private_ip_2.value" <<< "${terraform_output}")

cd ansible
ansible-playbook cassandra-playbook0.yaml

echo $public_ip1
echo 'this is ${public_ip1}'

ansible all -b -i '${public_ip1},' -m copy -a "src=./ansible/cassandra1.yaml dest=~/"
ansible all -b -i '${public_ip2},' -m copy -a "src=./ansible/cassandra2.yaml dest=~/"
    
# cat <<'EOF' >> ansible-playbook
# ---
#   - hosts: aws_cassandra_cluster
#     become: yes
#     remote_user: ubuntu
#     tasks:
#       - name: raplace IP1 on cassandra.yaml file
#         replace: 
#         path: ~/cassandra.yaml
#         regexp: PRIVATE_IP1
#         replace: ${private_ip1}

#       - name: raplace IP2 on cassandra.yaml file
#         replace: 
#         path: ~/cassandra.yaml
#         regexp: PRIVATE_IP2
#         replace: ${private_ip2}  

#       - name: copy the cassandra.yaml file
#         copy:
#         remote_src: yes
#           src: ~/cassandra.yaml
#           dest: /etc/cassandra/cassandra.yaml

#       - name: restart cassandra service
#         service:
#           name: cassandra
#           state: restarted
# EOF
