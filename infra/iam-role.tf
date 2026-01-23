resource "aws_iam_access_key" "club_app_key" {
  user = aws_iam_user.club_app.name
}

resource "aws_iam_user" "club_app" {
  name = "club-app-user"
  path = "/apps/"
}

data "aws_iam_policy_document" "club_app_policy_document" {
  statement {
    sid       = "AllowReadWriteToContentBucket"
    effect    = "Allow"
    actions   = [ "s3:GetObject", "s3:ListBucket", "s3:PutObject", "s3:DeleteObject" ]
    resources = [
      aws_s3_bucket.content_bucket.arn,
      "${aws_s3_bucket.content_bucket.arn}/*"
    ]
  }
}

resource "aws_iam_user_policy" "club_app_user_policy" {
  name = "club-app-user-policy"
  user = aws_iam_user.club_app.name

  policy = data.aws_iam_policy_document.club_app_policy_document.json
}

output "secret" {
  value = aws_iam_access_key.club_app_key.encrypted_secret
}
