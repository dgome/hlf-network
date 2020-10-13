#!/bin/bash

source ./scripts/util.sh
source ./scripts/env.sh

header "Orderer Org CA"

kubectl create -f k8s/org0/rca-org0.yaml

# Wait until pod is ready
echo "Waiting for pod"
kubectl wait --for=condition=ready pod -l app=rca-org0 --timeout=${CONTAINER_TIMEOUT} -n hlf
sleep $SERVER_STARTUP_TIME

kubectl exec -n hlf $(get_pods "rca-org0") -i -- bash /tmp/hyperledger/scripts/startNetwork/registerUsers/registerOrdererOrgUsers.sh

