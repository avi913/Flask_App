#!/bin/bash

# Jenkins credentials
JENKINS_URL="http://172.191.129.128:8080"
JOB_NAME="flask_project"
USER="avi"
API_TOKEN="1171f23f7c7e2c5a5135726b0a951310c1" 

# Trigger the job and check for success
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
  -X POST "$JENKINS_URL/job/$JOB_NAME/build" \
  --user "$USER:$API_TOKEN")

if [ "$RESPONSE" -eq 201 ]; then
  echo "Build triggered successfully for '$JOB_NAME'."
else
  echo "Failed to trigger build. HTTP status: $RESPONSE"
  echo "Check your Jenkins URL, credentials, and job name."
fi

