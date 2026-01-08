#!/bin/bash

REGION="us-east-1"
DAYS=7
CPU_THRESHOLD=5

echo "Cloud Idle Cost Analysis - AWS EC2"
echo "Region: $REGION"
echo "Idle Threshold: CPU < ${CPU_THRESHOLD}% (last ${DAYS} days)"
echo "--------------------------------------------------"

INSTANCES=$(aws ec2 describe-instances \
  --region $REGION \
  --query "Reservations[].Instances[?State.Name=='running'].InstanceId" \
  --output text)

if [ -z "$INSTANCES" ]; then
  echo "No running EC2 instances found."
  exit 0
fi

TOTAL_WASTE=0

for INSTANCE_ID in $INSTANCES; do

  AVG_CPU=$(aws cloudwatch get-metric-statistics \
    --region $REGION \
    --namespace AWS/EC2 \
    --metric-name CPUUtilization \
    --dimensions Name=InstanceId,Value=$INSTANCE_ID \
    --statistics Average \
    --period 86400 \
    --start-time $(date -u -d "$DAYS days ago" +%Y-%m-%dT%H:%M:%SZ) \
    --end-time $(date -u +%Y-%m-%dT%H:%M:%SZ) \
    --query "Datapoints[].Average" \
    --output text | awk '{sum+=$1} END {if (NR>0) print sum/NR; else print 0}')

  AVG_CPU=${AVG_CPU%.*}

  if [ "$AVG_CPU" -lt "$CPU_THRESHOLD" ]; then
    INSTANCE_TYPE=$(aws ec2 describe-instances \
      --region $REGION \
      --instance-ids $INSTANCE_ID \
      --query "Reservations[].Instances[].InstanceType" \
      --output text)

    MONTHLY_COST="~UNKNOWN"

    echo "Idle Instance Found:"
    echo "  Instance ID   : $INSTANCE_ID"
    echo "  Instance Type : $INSTANCE_TYPE"
    echo "  Avg CPU       : ${AVG_CPU}%"
    echo "  Monthly Cost  : $MONTHLY_COST"
    echo ""
  fi
done

echo "Analysis complete."
