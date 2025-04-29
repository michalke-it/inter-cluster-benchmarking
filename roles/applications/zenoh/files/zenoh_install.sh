#!/bin/bash

PAYLOAD_DIR=/tmp/benchfaster

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
for worker in $(sudo -E kubectl get nodes | grep -v control-plane | grep -v NAME | sed 's/\s.*$//'); do
    sudo -E kubectl label node $worker node-role.kubernetes.io/worker=worker
done
sudo -E kubectl apply -f ${PAYLOAD_DIR}/memory-defaults.yaml
sudo -E kubectl apply -f ${PAYLOAD_DIR}/zenoh.yaml
sudo -E kubectl apply -f ${PAYLOAD_DIR}/zenoh-svc.yaml
sudo -E kubectl apply -f ${PAYLOAD_DIR}/zenoh-cfgmap.yaml
sudo -E kubectl rollout status -w deployment/zenoh
