#!/usr/bin/env bash

export CLUSTER=my-k3d-cluster 

this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $this_dir/scripts/lib.sh 

k3d registry create registry.localhost --default-network k3d-cluster-network --port 12345 || true 

create-k3d-cluster $CLUSTER $this_dir/scripts/cluster.yaml

sleep 30

export ISTIO_VERSION=1.15.3
curl -L https://istio.io/downloadIstio | sh -

kubectl config use-context $CLUSTER

$this_dir/istio-1.15.3/bin/istioctl install --set profile=demo -y

sleep 30

echo "Installing httpbin..."

kubectl create ns httpbin
kubectl label ns httpbin istio-injection=enabled

kubectl apply -f $PWD/istio-1.15.3/samples/extauthz/local-ext-authz.yaml -n httpbin

sleep 30

echo "Defining external authorizer..."

kubectl apply -k ${PWD}/extension-provider/
kubectl rollout restart deployment/istiod -n istio-system

sleep 30

echo "Applying routing..."

kubectl apply -n httpbin -f ${PWD}/policies/ext-authz-auth-policy.yaml
kubectl apply -f $PWD/istio-1.15.3/samples/httpbin/httpbin-gateway.yaml -n httpbin

echo "Install completed."


