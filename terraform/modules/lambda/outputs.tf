output "event_rule_name" {
  value = aws_cloudwatch_event_rule.ec2_state_change.name
}

output "lambda_name" {
  value = aws_lambda_function.auto_healer.function_name
}
