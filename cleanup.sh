#!/usr/bin/env bash


export CLUSTER=my-k3d-cluster 

this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $this_dir/scripts/lib.sh 

delete-k3d-cluster $CLUSTER

rm -rf istio-*
