output "alarm_name" {
  value = aws_cloudwatch_metric_alarm.ec2_status_alarm.alarm_name
}

output "sns_topic_arn" {
  value = aws_sns_topic.alarm_topic.arn
}
