#!/bin/bash

kubectl get ns keycloak
if [[ $?  -eq 0 ]]; then
  echo "Skipping installation of keycloak because namespace already exists"
  echo "If you want to reinstall execute 'kubectl delete ns keycloak'"
else
echo "Install keycloak oauth service"

kubectl create ns keycloak

# create keycloak user and database - errors will be ignored if this step is repeated
# in case of trouble use the drop-keycloak.sql script
envsubst < create-db-keycloak.sql | kubectl exec psql-0 -i -n postgres -- psql -U admin -d postgres

# Installing ingress and keycloak
envsubst < ingress.yaml | kubectl apply -f -
envsubst < keycloak.yaml | kubectl apply -f -

echo "Installation done keycloak app"
fi # end if installation of whoami
