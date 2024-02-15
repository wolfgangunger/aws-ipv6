
resource "aws_iam_instance_profile" "ipv6_instance_profile" {
  name = "ipv6_instance_profile-${var.env}"
  role = aws_iam_role.ipv6_instance_role.name
}

data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ipv6_instance_role" {
  name               = "ipv6_instance_role-${var.env}"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}