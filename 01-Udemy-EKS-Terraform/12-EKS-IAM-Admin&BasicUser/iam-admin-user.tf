resource "aws_iam_user" "admin_user" {
  name = "${local.name}-eksadmin1"
  path = "/"
  force_destroy = true # to avoid delete conflict
  tags = local.common_tags
}

resource "aws_iam_policy_attachment" "admin_user" {
  name = aws_iam_user.admin_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}