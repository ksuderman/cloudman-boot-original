#!/usr/bin/env bash
set -u
KEY=~/.ssh/release-testing-2101.pem
IP=$1

function remote() {
	echo "\$> $1"
	ssh -i $KEY ubuntu@$IP $1
}

remote "kubectl create namespace cattle-system"
remote "helm repo add rancher https://releases.rancher.com/server-charts/stable"
remote "helm repo update"
remote "helm install -n cattle-system rancher rancher/rancher --set hostname=rancher.$IP.xip.io --set ingress.tls.source=letsEncrypt --set letsEncrypt.email=\"admin@cloudve.org\" --set letsEncrypt.environment=\"production\" --set letsEncrypt.ingress.class=nginx"


