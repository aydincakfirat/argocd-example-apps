#!/bin/bash

APP_NAME="nginx-app"
JOB_NAME="ready-for-analyze"
TIMEOUT_SECONDS=1200  # 20 dakika
INTERVAL_SECONDS=5

elapsed=0
waiting_message_shown=false

while [ "$elapsed" -lt "$TIMEOUT_SECONDS" ]; do
  job_info=$(argocd app get "$APP_NAME" --output json | jq -r \
    --arg job "$JOB_NAME" '.status.resources[] | select(.kind=="Job" and .name==$job)')

  health_status=$(echo "$job_info" | jq -r '.health.status')
  health_message=$(echo "$job_info" | jq -r '.health.message')

  if [ "$health_status" == "Healthy" ]; then
    echo "✅ Job is healthy: $health_message"
    exit 0
  elif [ "$waiting_message_shown" = false ]; then
    echo "⏳ Waiting... Current status: $health_status – $health_message"
    waiting_message_shown=true
  else
    remaining=$((TIMEOUT_SECONDS - elapsed))
    mins=$((remaining / 60))
    secs=$((remaining % 60))
    printf "⏳ Still waiting... %02d:%02d remaining\r" "$mins" "$secs"
  fi

  sleep "$INTERVAL_SECONDS"
  elapsed=$((elapsed + INTERVAL_SECONDS))
done

echo -e "\n❌ Timeout reached: Job did not become healthy within $((TIMEOUT_SECONDS/60)) minutes."
exit 1
