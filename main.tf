terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "members" {
  bucket = var.bucket_name 
}

resource "aws_s3_bucket_public_access_block" "members" {
  bucket                  = aws_s3_bucket.members.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "memebers" {
  depends_on = [
    aws_s3_bucket_public_access_block.members,
  ]
  bucket = aws_s3_bucket.members.id
  acl = "private"
}

resource "aws_s3_bucket_versioning" "members" {
  bucket = aws_s3_bucket.members.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_cors_configuration" "members" {
  bucket = aws_s3_bucket.members.id
  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}