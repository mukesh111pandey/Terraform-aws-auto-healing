terraform {
  backend "s3" {
    bucket         = "autohealing-terraform-bucket-mukesh-mp"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "autohealing-terraform-locks-mukesh-MP"
    encrypt        = true
  }
}
