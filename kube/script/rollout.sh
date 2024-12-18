#!/bin/bash
set -e

ssh $HARBOR_USER@$HARBOR_IP "
  mkdir -p ~/${ENV_NAME}-afcas/${SERVICE_NAME}
"
scp ./kube/script/configs.yaml $HARBOR_USER@$HARBOR_IP:~/${ENV_NAME}-afcas/${SERVICE_NAME}/configs.yaml
ssh $HARBOR_USER@$HARBOR_IP "
  set -e &&
  echo "List pods before apply configs" &&
  sudo kubectl get pods -n afcas-${ENV_NAME} &&
  echo "--------------------------" &&
  echo "Appling configs" &&
  sudo kubectl apply -f ~/${ENV_NAME}-afcas/${SERVICE_NAME}/configs.yaml -n afcas-${ENV_NAME} &&
  echo "--------------------------" &&
  echo "Waiting for rollout status" &&
  sleep 10 &&
  sudo kubectl logs --tail=500 deployment/${SERVICE_NAME} -n afcas-${ENV_NAME} &&
  sudo kubectl rollout status deployments ${SERVICE_NAME} -n afcas-${ENV_NAME} --timeout 300s &&
  echo "--------------------------" &&
  echo "List pod after apply configs" &&
  sudo kubectl get pods -n afcas-${ENV_NAME}
"
