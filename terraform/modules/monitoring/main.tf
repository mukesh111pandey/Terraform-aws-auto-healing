resource "aws_sns_topic" "alarm_topic" {
  name = "${var.project}-alarm-topic"
}

resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.alarm_topic.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}
resource "aws_cloudwatch_metric_alarm" "ec2_status_alarm" {
  alarm_name          = "${var.project}-ec2-status-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Maximum"
  threshold           = 1

  dimensions = {
    InstanceId = var.instance_id
  }

  alarm_description = "EC2 instance status check failed"

  alarm_actions = [aws_sns_topic.alarm_topic.arn]
}
