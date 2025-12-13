#!/bin/bash
yum update -y
yum install -y amazon-cloudwatch-agent

echo "EC2 instance started" > /var/log/health.log