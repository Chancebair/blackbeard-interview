resource "aws_dynamodb_table" "table" {
  name           = var.name
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = var.hash_key

  dynamic "attribute" {
      for_each = var.attributes
      content {
          name = attribute.value.name
          type = attribute.value.type
      }
  }

  ttl {
    attribute_name = ""
    enabled        = false
  }

  tags = {
    Name        = "dynamodb-table-1"
    Environment = "production"
  }
}