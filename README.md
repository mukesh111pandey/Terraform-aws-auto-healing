 Auto Healing Cloud Infrastructure using Terraform

This project demonstrates an auto-healing EC2 infrastructure on AWS using Terraform, CloudWatch Alarms, EventBridge, and Lambda.

## Architecture
- EC2 Instance
- CloudWatch Alarm (StatusCheckFailed)
- EventBridge Rule
- Lambda Function for Auto-Healing

## How it works
1. EC2 instance health is monitored by CloudWatch
2. If instance fails health checks, alarm is triggered
3. EventBridge invokes Lambda
4. Lambda stops and restarts the EC2 instance automatically

## Tools Used
- AWS EC2
- AWS Lambda
- AWS CloudWatch
- AWS EventBridge
- Terraform

## Author
Mukesh Pandey
