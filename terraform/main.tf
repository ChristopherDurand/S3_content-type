terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  s3_bucket = "unique-s3-bucket-name-globally"
}

resource "aws_s3_bucket" "frontend" {
  bucket = local.s3_bucket

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  policy = <<-EOF
  {
    "Version":"2012-10-17",
    "Statement":[
      {
        "Sid":"PublicRead",
        "Effect":"Allow",
        "Principal": "*",
        "Action":"s3:GetObject",
        "Resource":["arn:aws:s3:::${local.s3_bucket}/*"]
      }
    ]
  }
  EOF
}

resource "aws_s3_bucket_object" "object" {
  for_each = fileset("../build/", "**")
  bucket   = aws_s3_bucket.frontend.id
  key      = each.value
  source   = "../build/${each.value}"
  etag     = filemd5("../build/${each.value}")
}

output "bucket_endpoint" {
  value = aws_s3_bucket.frontend.website_endpoint
}
