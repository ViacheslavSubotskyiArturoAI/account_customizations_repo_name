#data "aws_organizations_organization" "this" {}
#
#resource "awscc_oam_sink" "this" {
#  name = "SampleSink"
#
#  policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [{
#      Effect    = "Allow"
#      Principal = "*"
#      Resource  = "*"
#      Action    = [
#        "oam:CreateLink",
#        "oam:UpdateLink"
#      ]
#      Condition = {
#        StringEquals = {
#          "aws:PrincipalOrgID" = data.aws_organizations_organization.this.id
#        }
#        "ForAllValues:StringEquals" = {
#          "oam:ResourceTypes" = [
#            "AWS::CloudWatch::Metric",
#            "AWS::Logs::LogGroup",
#            "AWS::XRay::Trace",
#            "AWS::ApplicationInsights::Application",
#            "AWS::InternetMonitor::Monitor"
#          ]
#        }
#      }
#    }]
#  })
#}
#
#output "oam_sink" {
#  value = awscc_oam_sink.this
#}
