#!/bin/bash

get_pods() {
  #1 - app name
  kubectl get pods -l app=$1 --field-selector status.phase=Running -n hlf-production-network --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' | head -n 1
}


if [ -z "$1" ]
then
  echo "Usage: ./podShell.sh deployment-name [container name]"
else
  if [ -z "$2" ]
  then
    kubectl exec -n hlf-production-network $(get_pods "$1")  -it -- sh
  else
    kubectl exec -n hlf-production-network $(get_pods "$1")  -c $2 -it -- sh
  fi
fi
