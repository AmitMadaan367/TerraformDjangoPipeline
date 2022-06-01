#code deploy policy
resource "aws_iam_role" "djangodeploy" {
  name = "djangodeploy-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}





resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.djangodeploy.name
}




resource "aws_codedeploy_app" "djangodeploy" {
  name = "djangodeploy-app"
}

resource "aws_sns_topic" "djangodeploy" {
  name = "djangodeploy-topic"
}


#here key as a name and value as a instance

resource "aws_codedeploy_deployment_group" "djangodeploy" {
  app_name              = aws_codedeploy_app.djangodeploy.name
  deployment_group_name = "djangodeploy-group"
  service_role_arn      = aws_iam_role.djangodeploy.arn

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "pub"
    }

  }

}
