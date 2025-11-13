#!/bin/bash

APP_NAME="nginx-app"
JOB_NAME="ready-for-analyze"

# ArgoCD'den Job'ın sağlık durumunu al
job_info=$(argocd app get "$APP_NAME" --output json | jq -r \
  --arg job "$JOB_NAME" '.status.resources[] | select(.kind=="Job" and .name==$job)')

# Sağlık durumu ve mesajı ayrıştır
health_status=$(echo "$job_info" | jq -r '.health.status')
health_message=$(echo "$job_info" | jq -r '.health.message')

# Duruma göre çıkış yap
if [ "$health_status" == "Healthy" ]; then
  echo "✅ Job is healthy: $health_message"
  exit 0
else
  echo "❌ Job is not healthy: $health_message"
  exit 1
fi
