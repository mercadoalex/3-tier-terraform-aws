//write a aws WAF resource to connect with my load balcancer
resource "aws_wafv2_web_acl" "web_acl" {
  name        = "web-acl"
  description = "Web ACL to protect the load balancer"
  scope       = "REGIONAL"
  default_action {
    allow {} #block the request
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        /*
         The AWSManagedRulesCommonRuleSet is a managed rule group provided by AWS 
         that includes a set of predefined rules designed to protect your web applications from common threats. 
        */
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "web-acl"
    sampled_requests_enabled   = true
  }
}
//Associte the WAF with the load balancer
resource "aws_wafv2_web_acl_association" "web_acl_association" {
  resource_arn = aws_lb.application-load-balancer.arn
  web_acl_arn  = aws_wafv2_web_acl.web_acl.arn
}