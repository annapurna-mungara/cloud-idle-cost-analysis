# Cloud Idle Cost Analysis

This project identifies **idle cloud compute resources** and estimates
their **monthly cost impact**.

The goal is to demonstrate a **simple, practical FinOps signal**:
resources that are running but underutilized.

## Current Scope
- Cloud: AWS
- Resource: EC2
- Signal: Low CPU utilization
- Output: Estimated monthly cost

## Why This Project
Idle resources are one of the most common and easiest cloud cost wastes
to identify and eliminate.

This project focuses on:
- Simplicity
- Transparency
- Actionable output

## Planned Enhancements
- Azure VM idle detection
- GCP compute idle detection
- Databricks idle cluster analysis
- Cost breakdown by service

## Usage

```bash
bash aws_idle_ec2.sh

## How It Works

1. Lists running EC2 instances
2. Fetches average CPU utilization from CloudWatch
3. Flags instances with CPU usage below 5%
4. Prints idle instances for cost review

This is a beginner-friendly FinOps example focused on
clarity over precision.

## Output Example

The script prints a tabular summary showing:
- Instance ID
- Instance type
- Average CPU utilization
- Estimated monthly cost (approximate)

This format makes it easy to review idle resources
during FinOps cost analysis.


