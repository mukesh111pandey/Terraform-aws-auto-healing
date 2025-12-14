# Intelligent Auto-Healing Cloud Infrastructure (AWS + Terraform + Lambda)

## Overview
This project implements an intelligent, self-healing cloud infrastructure on AWS.  
It automatically detects EC2 instance failures and replaces them using an event-driven architecture, eliminating manual recovery.
The infrastructure is fully provisioned using Terraform and follows real-world DevOps and SRE best practices.

## Architecture Flow
EC2 Failure → CloudWatch Alarm → EventBridge → Lambda → New EC2 → SNS Notification

## Technology Stack
- AWS EC2
- AWS Lambda (Python)
- Amazon CloudWatch
- Amazon EventBridge
- Amazon SNS
- Terraform (Infrastructure as Code)
- Linux

## Key Features
- Automatic EC2 failure detection
- Event-driven auto-healing mechanism
- Terraform modular architecture
- IAM least-privilege security model
- Real-time alerts using SNS
- Zero manual intervention

## Project Structure

auto-healing-infra/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── modules/
│       ├── vpc/
│       ├── ec2/
│       ├── lambda/
│       └── monitoring/
└── README.md

## How Auto-Healing Works
1. EC2 instance health check fails
2. CloudWatch alarm changes state to ALARM
3. EventBridge rule triggers Lambda
4. Lambda launches a replacement EC2 instance
5. SNS sends notification to the user

## Infrastructure Provisioning
The following AWS resources are provisioned using Terraform:
- VPC and public subnets
- EC2 instance
- IAM roles and policies
- Lambda function
- CloudWatch alarms
- EventBridge rules
- SNS topic and subscription

## Deployment Steps

cd terraform
terraform init
terraform plan
terraform apply

## Testing the Auto-Healing
1. Stop the EC2 instance manually
2. CloudWatch alarm is triggered
3. Lambda function executes automatically
4. A new EC2 instance is created
5. SNS notification is sent

## Security Best Practices
- IAM roles with least privilege
- No hard-coded AWS credentials
- Event-driven architecture
- Infrastructure as Code using Terraform

## Real-World Use Cases
- High availability systems
- Production incident auto-recovery
- Reduced Mean Time To Recovery (MTTR)
- SRE-based self-healing infrastructure

## Author
Mukesh Pandey  
DevOps / Cloud Engineer

## Project Highlights
This project demonstrates real-world DevOps practices including automation, monitoring, and self-healing cloud infrastructure on AWS.
