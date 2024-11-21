#Task: Deploy an application load balancer with a web application firewall (WAF).

resource "aws_lb" "app_lb" {
  name               = "secure-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-12345678"]
  subnets            = ["subnet-12345678", "subnet-87654321"]
}

resource "aws_wafv2_web_acl" "app_waf" {
  name        = "app-waf"
  scope       = "REGIONAL"
  default_action {
    allow {}
  }
  rule {
    name     = "block-ip"
    priority = 1

    action {
      block {}
    }
    statement {
      ip_set_reference_statement {
        arn = "arn:aws:wafv2:us-west-2:123456789012:ipset/blocklist"
      }
    }
  }
}

resource "aws_wafv2_web_acl_association" "lb_association" {
  resource_arn = aws_lb.app_lb.arn
  web_acl_arn  = aws_wafv2_web_acl.app_waf.arn
}
