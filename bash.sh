#!bin/bash

dir_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
dir_path="${dir_path}"

#terraform



sleep 15


terraform_output=$(terraform output --json) 


public_ip1=$(jq -re "instance_public_ip_1.value" <<< "${terraform_output}") 

cat <<EOF | ansible-playbook 
---
  - hosts: aws_cassandra_cluster
    become: yes
    remote_user: ubuntu
    tasks:  
      - name: add cassandra gpg key to apt
        ansible.builtin.apt_key:
          url: https://www.apache.org/dist/cassandra/KEYS
          state: present
      
      - name: add cassandra repo tp apt
        ansible.builtin.apt_repository:
          repo: deb http://www.apache.org/dist/cassandra/debian 40x main
          state: present
          filename: cassandra
       
      - name: install cassandra
        apt:
          name: cassandra
          state: present    
      
      - name: remove cassandra.yaml file
        file:
          state: absent
          path: /etc/cassandra/cassandra.yaml 
      
      - name: copy the cassandra.yaml file
        copy:
          src: ./cassandra.yaml
          dest: /etc/cassandra/cassandra.yaml

      - name: restart cassandra service
        ansible.builtin.service:
          name: cassandra
          state: restarted
EOF         


