#!/usr/bin/env bash
set -e

#KEY=~/.ssh/release-testing-2101.pem
KEY=~/.ssh/ks-cluster.pem

if [[ ! -e $1 ]] ; then
  echo "Could not find the inventory file $1"
  exit 1
fi

set -u
IP=$(cat $1 | grep _host | cut -d= -f2)

function remote() {
	echo "\$> $1"
	ssh -i $KEY ubuntu@$IP $1
}

#remote "kubectl create namespace cattle-system"
#remote "helm repo add rancher https://releases.rancher.com/server-charts/stable"
#remote "helm repo update"
ansible-playbook -i $1 rancher.yml
remote "helm install -n cattle-system rancher rancher/rancher --set hostname=rancher.$IP.xip.io --set ingress.tls.source=letsEncrypt --set letsEncrypt.email=\"admin@cloudve.org\" --set letsEncrypt.environment=\"production\" --set letsEncrypt.ingress.class=nginx"


