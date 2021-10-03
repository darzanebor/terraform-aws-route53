data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "Allow full access for Key Administrators"
    actions   = ["*"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.default_admin}"]
    }
  }
  statement {
    sid       = "Allow use of the CMK for DNSSEC"
    actions   = ["kms:DescribeKey", "kms:GetPublicKey", "kms:Sign", "kms:Verify"]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["dnssec-route53.amazonaws.com"]
    }
  }
}

resource "aws_kms_key" "this" {
  depends_on               = [data.aws_iam_policy_document.this]
  policy                   = data.aws_iam_policy_document.this.json
  customer_master_key_spec = "ECC_NIST_P256"
  key_usage                = "SIGN_VERIFY"
  deletion_window_in_days  = 7
  enable_key_rotation      = false
}

resource "aws_route53_key_signing_key" "this" {
  name                       = aws_route53_zone.this.name
  hosted_zone_id             = aws_route53_zone.this.id
  key_management_service_arn = aws_kms_key.this.arn
}
