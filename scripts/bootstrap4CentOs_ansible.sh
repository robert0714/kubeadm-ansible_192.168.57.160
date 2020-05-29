#!/bin/bash

#set -e 


function set_hosts() {
cat <<EOF > ~/hosts
127.0.0.1   localhost
::1         localhost

192.168.57.161 k8s-n1
192.168.57.162 k8s-n2
192.168.57.160 k8s-m1

EOF
}

set -e
HOST_NAME=$(hostname)
OS_NAME=$(awk -F= '/^NAME/{print $2}' /etc/os-release | grep -o "\w*"| head -n 1)

if [ ${HOST_NAME} == "k8s-m1" ]; then
  case "${OS_NAME}" in
    "CentOS")
      sudo yum install -y epel-release
      sudo yum install -y git ansible sshpass python-netaddr openssl-devel
    ;;
    "Ubuntu")
#      sudo sed -i 's/us.archive.ubuntu.com/tw.archive.ubuntu.com/g' /etc/apt/sources.list
#      sudo apt-add-repository -y ppa:ansible/ansible
      sudo apt-get update && sudo apt-get install -y ansible git sshpass python-netaddr libssl-dev
    ;;
    *)
      echo "${OS_NAME} is not support ..."; exit 1
  esac

#  yes "/root/.ssh/id_rsa" | sudo ssh-keygen -t rsa -N ""
#  HOSTS="192.16.35.10 192.16.35.11 192.16.35.12"
#  for host in ${HOSTS}; do
#     sudo sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no vagrant@${host} "sudo mkdir -p /root/.ssh"
#     sudo cat /root/.ssh/id_rsa.pub | \
#          sudo sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no vagrant@${host} "sudo tee /root/.ssh/authorized_keys"
#  done

  cd /vagrant
  set_hosts
  sudo cp ~/hosts /etc/
  sudo ansible-playbook -e network_interface=eth1  ansible/site.yaml  -e DOCKER_API_VERSION=1.39  -i ansible/hosts.ini
else
  set_hosts
  sudo cp ~/hosts /etc/
  case "${OS_NAME}" in
    "CentOS")
      sudo yum install -y epel-release
    ;;
    "Ubuntu")
      sudo apt-add-repository -y ppa:ansible/ansible
    ;;
    *)
      echo "${OS_NAME} is not support ..."; exit 1
  esac
fi
