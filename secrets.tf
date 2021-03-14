# Secret to store cert.pem file
resource "aws_secretsmanager_secret" "secret" {
  name = local.prefix
}
