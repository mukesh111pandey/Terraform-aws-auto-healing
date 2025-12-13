# -----------------------------
# VPC Module
# -----------------------------
module "vpc" {
  source = "./modules/vpc"

  project              = var.project
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_1_cidr = "10.0.1.0/24"
  public_subnet_2_cidr = "10.0.2.0/24"
  az1                  = "ap-south-1a"
  az2                  = "ap-south-1b"
}

# -----------------------------
# EC2 Module
# -----------------------------
module "ec2" {
  source = "./modules/ec2"

  project          = var.project
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_ids[0]

  ami_id        = "ami-0f5ee92e2d63afc18" # Amazon Linux 2 (ap-south-1)
  instance_type = "t2.micro"
}

# -----------------------------
# Lambda Module
# -----------------------------
module "lambda" {
  source = "./modules/lambda"

  project         = var.project
  lambda_zip_path = var.lambda_zip_path
  lambda_handler  = var.lambda_handler
  lambda_runtime  = var.lambda_runtime
  sns_topic_arn   = module.monitoring.sns_topic_arn
}

# -----------------------------
# Monitoring Module
# -----------------------------
module "monitoring" {
  source = "./modules/monitoring"

  project     = var.project
  instance_id = module.ec2.instance_id
  alarm_email = "mukeshpandey98389838@gmail.com"
}
