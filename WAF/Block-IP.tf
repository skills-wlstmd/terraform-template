resource "aws_wafv2_web_acl" "waf" {
  name  = "<env>"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name = "block-ip"
    priority = 0

    action {
      block {}
    }

    visibility_config {
      metric_name = "block-ip"
      cloudwatch_metrics_enabled = true
      sampled_requests_enabled = true
    }

    statement {
      rate_based_statement {
        limit = "number"
        aggregate_key_type = "IP"
        }
      }
    }

  visibility_config {
    metric_name                = "<env>"
    sampled_requests_enabled   = true
    cloudwatch_metrics_enabled = true
  }

  rule {
    name     = "block-specific-ip"
    priority = 1

    action {
      block {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.blocked_ips.arn
      }
    }

    visibility_config {
      metric_name                = "block-specific-ip"
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
    }
  }
}

resource "aws_wafv2_ip_set" "blocked_ips" {
  name        = "blocked-ips"
  scope       = "REGIONAL"
  ip_address_version = "IPV4"

  addresses = [
    "192.168.1.1/32",
    "203.0.113.0/24"
  ]
}