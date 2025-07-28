resource "aws_s3_bucket" "static_site" {
  bucket        = "limtruong-static-site"
  force_destroy = true // Allows deletion of bucket with objects (for dev environment)
  tags          = local.tags
}

resource "aws_s3_bucket_public_access_block" "public_static_site" {
  bucket                  = aws_s3_bucket.static_site.id
  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "static_site_policy" {
  bucket = aws_s3_bucket.static_site.id
  policy = file("${path.module}/s3_static_policy.json")

  depends_on = [aws_s3_bucket_public_access_block.public_static_site]
}

resource "aws_s3_bucket_website_configuration" "static_web_config" {
  bucket = aws_s3_bucket.static_site.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "limweb" {
  for_each     = fileset(path.module, "./limweb/**/*")
  bucket       = aws_s3_bucket.static_site.id
  key          = replace(each.value, "./limweb/", "")
  source       = "${path.module}/${each.value}"
  etag         = filemd5("${path.module}/${each.value}")
  content_type = lookup(local.mime_types, regex("[^.]*$", each.value), "application/octet-stream")
}
