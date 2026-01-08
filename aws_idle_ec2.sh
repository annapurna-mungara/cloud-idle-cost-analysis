#!/bin/bash

REGION="us-east-1"
DAYS=7
CPU_THRESHOLD=5

echo ""
echo "Cloud Idle Cost Analysis - AWS EC2"
echo "Region: $REGION | Idle CPU < ${CPU_THRESHOLD}% | Last ${DAYS} days"
echo ""

printf "+----------------------+---------------+----------+------------------+\n"
printf "| %-20s | %-13s | %-8s | %-16s |\n" "Instance ID" "Instance Type" "Avg CPU%" "Monthly Cost USD"
printf "+----------------------+---------------+----------+------------------+\n"

INSTANCES=$(aws ec2 describe-instances \
  --region $REGION \
  --query "Reservations[].Instances[?State.Name=='running'].InstanceId" \
  --output text)

COUNT=0

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
    --output text | awk '{sum+=$1} END {if (NR>0) printf "%.0f", sum/NR; else print 0}')

  if [ "$AVG_CPU" -lt "$CPU_THRESHOLD" ]; then
    INSTANCE_TYPE=$(aws ec2 describe-instances \
      --region $REGION \
      --instance-ids $INSTANCE_ID \
      --query "Reservations[].Instances[].InstanceType" \
      --output text)

    MONTHLY_COST="~UNKNOWN"

    printf "| %-20s | %-13s | %-8s | %-16s |\n" \
      "$INSTANCE_ID" "$INSTANCE_TYPE" "$AVG_CPU" "$MONTHLY_COST"

    COUNT=$((COUNT + 1))
  fi
done

printf "+----------------------+---------------+----------+------------------+\n"
echo ""
echo "Total Idle Instances: $COUNT"
echo ""
