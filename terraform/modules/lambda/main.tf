# =====================================================
# IAM ROLE FOR LAMBDA
# =====================================================
resource "aws_iam_role" "lambda_role" {
  name = "${var.project}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# Basic logging permissions
resource "aws_iam_role_policy_attachment" "basic_exec" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# EC2 + SNS permissions
data "aws_iam_policy_document" "lambda_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "ec2:RunInstances",
      "ec2:TerminateInstances",
      "ec2:CreateTags",
      "ec2:DescribeImages"
    ]
    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["sns:Publish"]
    resources = var.sns_topic_arn == "" ? [] : [var.sns_topic_arn]
  }
}

resource "aws_iam_role_policy" "lambda_inline" {
  name   = "${var.project}-lambda-policy"
  role  = aws_iam_role.lambda_role.id
  policy = data.aws_iam_policy_document.lambda_policy.json
}

# =====================================================
# LAMBDA FUNCTION
# =====================================================
resource "aws_lambda_function" "auto_healer" {
  function_name = "${var.project}-auto-healer"
  filename      = var.lambda_zip_path
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  role          = aws_iam_role.lambda_role.arn

  source_code_hash = filebase64sha256(var.lambda_zip_path)

  environment {
    variables = {
      SNS_TOPIC_ARN = var.sns_topic_arn
    }
  }
}

# =====================================================
# EVENTBRIDGE → EC2 STATE CHANGE (REAL AUTO HEALING)
# =====================================================
resource "aws_cloudwatch_event_rule" "ec2_state_change" {
  name = "${var.project}-ec2-state-change"

  event_pattern = jsonencode({
    source = ["aws.ec2"],
    detail-type = ["EC2 Instance State-change Notification"],
    detail = {
      state = ["stopped", "terminated"]
    }
  })
}

resource "aws_cloudwatch_event_target" "ec2_to_lambda" {
  rule      = aws_cloudwatch_event_rule.ec2_state_change.name
  target_id = "lambda"
  arn       = aws_lambda_function.auto_healer.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowEC2StateChange"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auto_healer.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2_state_change.arn
}
