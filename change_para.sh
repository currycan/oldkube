sed -e "s/10.88.88.111/10.177.37.216/g" -i /etc/ansible/roles/cluster-default/defaults/main.yml
sed -e "s/10.88.88.9/10.177.92.8/g" -i /etc/ansible/roles/cluster-default/defaults/main.yml
sed -e "s/10.88.88.3/10.177.92.3/g" -i /etc/ansible/roles/cluster-default/defaults/main.yml
sed -e "s/10.88.88./10.177.92./g" -i /etc/ansible/roles/cluster-default/defaults/main.yml
sed -e "s/docker_enable_proxy: true/docker_enable_proxy: false/g" -i /etc/ansible/roles/cluster-default/defaults/main.yml
