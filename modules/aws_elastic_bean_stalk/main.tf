resource "aws_elastic_beanstalk_application" "tftest" {
  name        = "sample-application"
  description = "tf-sample-application"
}

resource "aws_elastic_beanstalk_environment" "tfenvtest" {
  name                = "ritvik-sample-env"
  application         = aws_elastic_beanstalk_application.tftest.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.13 running Python 3.8"

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", var.private_subnet_ids)
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = join(",", var.public_subnet_ids)
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.ins_profile.arn
  }
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "ConfigDocument"
    value     = jsonencode(local.settings)
  }
}


locals {
  settings={
    "Version": 1,
    "Rules": {
        "Environment": {
            "ELB": {
                "ELBRequests4xx": {
                    "Enabled": false
                }
            },
            "Application": {
                "ApplicationRequests4xx": {
                    "Enabled": false
                }
            }
        }
    }
}
}


data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "instance" {
  name               = "instance_role"
  path               = "/system/"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
}

resource "aws_iam_instance_profile" "ins_profile" {
  name = "test_profile"
  role = aws_iam_role.instance.name 
}

resource "aws_iam_policy" "policy" {

  policy = "${file("./modules/aws_elastic_bean_stalk/policy.json")}"
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "policy-attachment"
  roles      = [aws_iam_role.instance.name]
  policy_arn = aws_iam_policy.policy.arn
}