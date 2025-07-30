#########################
### S3 Static Website ###
#########################

resource "aws_s3_bucket" "static_website" {
  bucket        = var.bucket_name
  force_destroy = true // Allows deletion of bucket with objects (for dev environment)
  tags          = var.tags
}

resource "aws_s3_bucket_public_access_block" "public_static_website" {
  bucket                  = aws_s3_bucket.static_website.id
  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "static_website_policy" {
  bucket = aws_s3_bucket.static_website.id
  policy = file(var.bucket_policy)

  depends_on = [aws_s3_bucket_public_access_block.public_static_website]
}

resource "aws_s3_bucket_website_configuration" "static_web_config" {
  bucket = aws_s3_bucket.static_website.bucket

  index_document {
    suffix = var.index_suffix
  }

  error_document {
    key = var.error_file
  }
}

resource "aws_s3_object" "static_website_assets" {
  for_each     = fileset(var.asset_path, "**/*")
  bucket       = aws_s3_bucket.static_website.id
  key          = each.value
  source       = "${var.asset_path}/${each.value}"
  etag         = filemd5("${var.asset_path}/${each.value}")
  content_type = lookup(var.mime_types, regex("[^.]*$", each.value), "application/octet-stream")
}
