terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.website.id
  key    = "index.html"
  content = <<EOF
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial scale=1">
    </head>
    <body>
        <h1>Cheeseburger</h1>
        <h2>Beeeeeef</h2>
        Burgers <b>WITH CHEESE</b>
        <hr>
        Take 2 buns.
        <br>
        Slap a beef patty in between.
        <br>
        Slap on some cheese.
        <br>
        Maybe add pickles I dunno.
        <br>
        <br>
        <br>
        RIP BRISKET BURGER
        <br>
        <img src="Borg.jpg">
        <br>
        <ul>
            <li>Top Bun</li>
            <li>Tomatoes and maybe pickles</li>
            <li>Lettuce</li>
            <li>CHEESE</li>
            <li>Patty</li>
            <li>Sauce
                <Ul>
                    <li>Barbecue</li>
                    <li>Ketchup is acceptable but you will be judged</li>
                    <li>Only Dijon mustard if you want mustard</li>
                </Ul>
            </li>
            <li>Bottom Bun</li>
        </ul>
    </body>
</html>


