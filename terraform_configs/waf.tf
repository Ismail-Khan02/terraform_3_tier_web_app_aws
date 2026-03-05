# WAF WebACL
resource "aws_wafv2_web_acl" "main" {
    name = "main-web-acl"
    description = "WAF ACL for the web application"
    scope = "REGIONAL"

    default_action {
        allow {}
    }

    visibility_config {
        sampled_requests_enabled = true
        cloudwatch_metrics_enabled = true
        metric_name = "main-web-acl"
    }

    # Rule 1: AWS Common Rule Set (CRS) - Provides protection against common web exploits
    rule {
        name     = "AWS-AWSManagedRulesCommonRuleSet"
        priority = 1

        override_action {
            none {}
        }

        statement {
            managed_rule_group_statement {
                name        = "AWSManagedRulesCommonRuleSet"
                vendor_name = "AWS"
            }
        }

        visibility_config {
            sampled_requests_enabled = true
            cloudwatch_metrics_enabled = true
            metric_name = "AWSManagedRulesCommonRuleSet"
        }
    }

    # Rule 2: AWS Known Bad Inputs Rule Set - Blocks requests with known bad inputs
    rule {
        name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
        priority = 2

        override_action {
            none {}
        }

        statement {
            managed_rule_group_statement {
                name        = "AWSManagedRulesKnownBadInputsRuleSet"
                vendor_name = "AWS"
            }
        }

        visibility_config {
            sampled_requests_enabled = true
            cloudwatch_metrics_enabled = true
            metric_name = "AWSManagedRulesKnownBadInputsRuleSet"
        }
    }

    # Rule 3: AWS SQLi Rule Set - Protects against SQL injection attacks
    rule {
        name     = "AWS-AWSManagedRulesSQLiRuleSet"
        priority = 3

        override_action {
            none {}
        }

        statement {
            managed_rule_group_statement {
                name        = "AWSManagedRulesSQLiRuleSet"
                vendor_name = "AWS"
            }
        }

        visibility_config {
            sampled_requests_enabled = true
            cloudwatch_metrics_enabled = true
            metric_name = "AWSManagedRulesSQLiRuleSet"
        }
    }

    # Rule 4: Amazon IP Reputation List - Blocks requests from known malicious IP addresses
    rule {
        name     = "AWS-AWSManagedRulesAmazonIpReputationList"
        priority = 4

        override_action {
            none {}
        }

        statement {
            managed_rule_group_statement {
                name        = "AWSManagedRulesAmazonIpReputationList"
                vendor_name = "AWS"
            }
        }

        visibility_config {
            sampled_requests_enabled = true
            cloudwatch_metrics_enabled = true
            metric_name = "AWSManagedRulesAmazonIpReputationList"
        }
    }

}

# Attach WAF to the Application Load Balancer
resource "aws_wafv2_web_acl_association" "alb_association" {
    resource_arn = aws_lb.external-alb.arn
    web_acl_arn  = aws_wafv2_web_acl.main.arn
}

# CloudWatch Metrics and Logging for WAF
resource "aws_cloudwatch_log_group" "waf_logs" {
    name = "/aws/waf/main-web-acl-logs"
    retention_in_days = 7

    tags = {
        Name        = "waf-log-group"
        Environment = var.environment
    }
}

# Enable WAF logging to CloudWatch
resource "aws_wafv2_web_acl_logging_configuration" "waf_logging" {
    resource_arn = aws_wafv2_web_acl.main.arn

    log_destination_configs = [
        aws_cloudwatch_log_group.waf_logs.arn
    ]
}