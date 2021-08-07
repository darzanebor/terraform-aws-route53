resource "aws_route53_zone" "this" {
  name          = var.domain
  force_destroy = false
}

module "records" {
  source     = "terraform-aws-modules/route53/aws//modules/records"
  version    = "~> 2.0"
  records    = var.records
  zone_name  = aws_route53_zone.this.name
  depends_on = [aws_route53_zone.this]
}
