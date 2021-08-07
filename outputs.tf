
output "aws_route53_zone_id" {
  value = aws_route53_zone.this.id
}

output "aws_route53_ds_record" {
  sensitive = true
  value     = aws_route53_key_signing_key.this.ds_record
}

output "aws_route53_dnskey_record" {
  sensitive = true
  value     = aws_route53_key_signing_key.this.dnskey_record
}
