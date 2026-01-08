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
