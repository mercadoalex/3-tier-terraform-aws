######Load balancer #####
output "lb_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.application-load-balancer.dns_name
} 
# Output the FQDNs of the DNS validation records for the root domain
output "dns_validation_fqdns_primary" {
  value       = [for record in aws_route53_record.my_dns_record_primary : record.fqdn]
  description = "The FQDNs of the DNS validation records for the ACM certificate for the root domain."
}
/*
output "dns_validation_fqdns" {
  value = [for record in aws_route53_record.aws_acm_certificate_validation.alumno04_hosted_zone: record.fqdn]
  description = "The FQDNs of the DNS validation records for the ACM certificate."
} */