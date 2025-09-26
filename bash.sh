#!/bin/bash
set -e

NAMESPACE="data-service"
GRAVITINO_PORT=8090
METALAKE_NAME="example_metalake"

echo "=== [1/4] Install Gravitino ==="
helm upgrade --install gravitino ./gravitino/gravitino -n $NAMESPACE

echo "Waiting for Gravitino to start..."
kubectl rollout status deployment/gravitino -n $NAMESPACE

echo "=== [2/4] Port-forward Gravitino service to localhost ($GRAVITINO_PORT) ==="
# run port-forward in background, redirect logs to /tmp
kubectl port-forward svc/gravitino -n $NAMESPACE $GRAVITINO_PORT:$GRAVITINO_PORT > /tmp/gravitino-port-forward.log 2>&1 &
PF_PID=$!
sleep 5  # wait a few seconds for service to be ready

echo "=== [3/4] Create Metalake: $METALAKE_NAME ==="
curl -s -o /dev/null -w "%{http_code}" -X POST "http://localhost:$GRAVITINO_PORT/api/metalakes" \
  -H "Content-Type: application/json" \
  -d "{
        \"name\": \"$METALAKE_NAME\",
        \"comment\": \"Metalake created automatically by deploy script\",
        \"properties\": {}
      }"

echo -e "\nMetalake $METALAKE_NAME has been created."

echo "=== [4/4] Install Airflow and Trino ==="
helm upgrade --install airflow ./airflow -n $NAMESPACE
helm upgrade --install trino ./trino -n $NAMESPACE

echo "Deployment completed successfully!"

# cleanup port-forward when script exits
trap "kill $PF_PID" EXIT
