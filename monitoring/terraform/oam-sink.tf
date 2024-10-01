data "aws_organizations_organization" "this" {}

resource "aws_oam_sink" "this" {
  name = "CentralMonitoringSink"
}

resource "aws_oam_sink_policy" "this" {
  sink_identifier = aws_oam_sink.this.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Resource  = "*"
      Action = [
        "oam:CreateLink",
        "oam:UpdateLink"
      ]
      Condition = {
        StringEquals = {
          "aws:PrincipalOrgID" = data.aws_organizations_organization.this.id
        }
        "ForAllValues:StringEquals" = {
          "oam:ResourceTypes" = [
            "AWS::CloudWatch::Metric",
            "AWS::Logs::LogGroup",
            "AWS::XRay::Trace",
            "AWS::ApplicationInsights::Application",
            "AWS::InternetMonitor::Monitor"
          ]
        }
      }
    }]
  })
}

output "oam_sink_arn" {
  value = aws_oam_sink.this.arn
}
