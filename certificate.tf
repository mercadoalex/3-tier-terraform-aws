# Reference the existing Route 53 hosted zone
data "aws_route53_zone" "primary" {
  name = "pelucornio.link"
}

# Create Route 53 hosted zone for añlumno04.pelucornio.link
resource "aws_route53_zone" "alumno04" {
  name = "alumno04.pelucornio.link"
  tags = {
    name = "development_dns_zone"
  }
}

# Set up NS records in pelucornio.link to point to alumno04.pelucornio.link zone's NS servers
resource "aws_route53_record" "dev_ns" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "alumno04"
  type    = "NS"
  ttl     = 300
  records = aws_route53_zone.alumno04.name_servers
}

# Create a CNAME record in the primary hosted zone to point to the subdomain
resource "aws_route53_record" "primary_to_alumno_cname" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "www.pelucornio.link"
  type    = "CNAME"
  ttl     = 300
  records = ["alumno04.pelucornio.link"]
}

# Create the ACM certificate with DNS validation for the root domain
resource "aws_acm_certificate" "primary_hosted_zone" {
  domain_name       = "*.pelucornio.link"
  validation_method = "DNS"

  tags = {
    Name        = "certificateForDevelopmentPrimary"
    Scope       = "vpn_server"
    Environment = "dev"
  }
}

# Create DNS validation records in the root domain's hosted zone
resource "aws_route53_record" "my_dns_record_primary" {
  for_each = {
    for dvo in aws_acm_certificate.primary_hosted_zone.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.primary.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

# Validate the ACM certificate for the root domain
resource "aws_acm_certificate_validation" "primary_hosted_zone" {
  certificate_arn         = aws_acm_certificate.primary_hosted_zone.arn
  validation_record_fqdns = [for record in aws_route53_record.my_dns_record_primary : record.fqdn]

  timeouts {
    create = "10m" # Increased timeout to 60 minutes
  }
}

# Create the ACM certificate with DNS validation for the subdomain
resource "aws_acm_certificate" "vpn_server" {
  domain_name       = "alumno04.pelucornio.link"
  validation_method = "DNS"

  tags = {
    Name        = "certificateForDevelopmentSecondary"
    Scope       = "vpn_server"
    Environment = "dev"
  }
}
#OJO 
#There is There is no need to create a separate certificate for the subdomain if the wildcard certificate is already in place.
# Create DNS validation records in the subdomain's hosted zone
resource "aws_route53_record" "my_dns_record_vpn_server" {
  for_each = {
    for dvo in aws_acm_certificate.vpn_server.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = aws_route53_zone.alumno04.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

# Validate the ACM certificate for the subdomain
resource "aws_acm_certificate_validation" "vpn_server" {
  certificate_arn         = aws_acm_certificate.vpn_server.arn
  validation_record_fqdns = [for record in aws_route53_record.my_dns_record_vpn_server : record.fqdn]

  timeouts {
    create = "10m" # Increased timeout to 60 minutes
  }
}

# Create DNS record to point to the load balancer in the subdomain
resource "aws_route53_record" "lb_alias" {
  zone_id = aws_route53_zone.alumno04.zone_id
  name    = "alumno04.pelucornio.link"
  type    = "A"

  alias {
    name                   = aws_lb.application-load-balancer.dns_name
    zone_id                = aws_lb.application-load-balancer.zone_id
    evaluate_target_health = true
  }
}

# Create a listener for the load balancer that uses the ACM certificate for the root domain
/*
resource "aws_lb_listener" "https_listener_root" {
  load_balancer_arn = aws_lb.application-load-balancer.arn
  port              = "8443"
  protocol          = "HTTPS"

  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.primary_hosted_zone.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-target-group.arn
  }

  depends_on = [aws_acm_certificate_validation.primary_hosted_zone]
}
*/
# Create a listener for the load balancer that uses the ACM certificate for the subdomain
resource "aws_lb_listener" "https_listener_subdomain" {
  load_balancer_arn = aws_lb.application-load-balancer.arn
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = aws_acm_certificate.vpn_server.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-target-group.arn
  }

  depends_on = [aws_acm_certificate_validation.vpn_server]
}
