# data.template_file.cognito_iam_assume_role_policy.rendered
data "template_file" "cognito_iam_assume_role_policy" {
  template = "${
    file("${path.module}/iam/policies/assume-role/cognito-identity.json")
  }"
  vars = {
    cognito_identity_pool_id = "${aws_cognito_identity_pool._.id}"
  }
}

data "template_file" "cognito_developer_assume_role" {
  template = "${
    file("${path.module}/iam/policies/assume-role/developer-role.json")
  }"
}

data "template_file" "cognito_ops_assume_role" {
  template = "${
    file("${path.module}/iam/policies/assume-role/ops-role.json")
  }"
}


# aws_iam_role.cognito
resource "aws_iam_role" "cognito" {
  name = "cognito-identity"

  assume_role_policy = data.template_file.cognito_iam_assume_role_policy.rendered
}

# aws_cognito_user_pool._
resource "aws_cognito_user_pool" "_" {
  name = "cognito_user_pool"


  admin_create_user_config {
    allow_admin_create_user_only = false
  }


  schema {
    name                = "type"
    attribute_data_type = "String"
    mutable             = false
  }


  lifecycle {
    ignore_changes = ["schema"]
  }
}

# aws_cognito_user_pool_client._
resource "aws_cognito_user_pool_client" "_" {
  name = "cognito_user_pool"

  user_pool_id    = "${aws_cognito_user_pool._.id}"
  generate_secret = false

}



# aws_cognito_identity_pool._
resource "aws_cognito_identity_pool" "_" {
  identity_pool_name      = "${var.cognito_identity_pool_name}"
  developer_provider_name = "${var.cognito_identity_pool_provider}"

  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id               = "${aws_cognito_user_pool_client._.id}"
    server_side_token_check = true

    provider_name = "cognito-idp.${
      var.region
      }.amazonaws.com/${
      aws_cognito_user_pool._.id
    }"
  }
}


# aws_cognito_identity_pool_roles_attachment._
resource "aws_cognito_identity_pool_roles_attachment" "_" {
  identity_pool_id = "${aws_cognito_identity_pool._.id}"

  roles = {
    "authenticated" = "${aws_iam_role.cognito.arn}"
  }
}



resource "aws_iam_group" "developers" {
  name = "developers"
  path = "/dev/"
}

resource "aws_iam_group" "ops" {
  name = "Operations"
  path = "/ops/"
}

#Aws Cognito user groups

resource "aws_cognito_user_group" "devGroup" {
  name         = "developers"
  user_pool_id = aws_cognito_user_pool._.id
  description  = "Developer"
  role_arn     = aws_iam_role.developer_role.arn
}

resource "aws_cognito_user_group" "opsGroup" {
  name         = "operations"
  user_pool_id = aws_cognito_user_pool._.id
  description  = "OPS"
  role_arn     = aws_iam_role.developer_role.arn
}

resource "null_resource" "cognito_user" {

  triggers = {
    user_pool_id = aws_cognito_user_pool._.id
  }

  provisioner "local-exec" {
    command = <<EOT
     aws cognito-idp admin-create-user --user-pool-id ${aws_cognito_user_pool._.id} --username Eugene --user-attributes Name=custom:type,Value=developer --region ${var.region}
     aws cognito-idp admin-create-user --user-pool-id ${aws_cognito_user_pool._.id} --username Milo --user-attributes Name=custom:type,Value=developer --region ${var.region}
     aws cognito-idp admin-create-user --user-pool-id ${aws_cognito_user_pool._.id} --username Abigail --user-attributes Name=custom:type,Value=developer --region ${var.region}
     aws cognito-idp admin-create-user --user-pool-id ${aws_cognito_user_pool._.id} --username Aidan --user-attributes Name=custom:type,Value=developer --region ${var.region}
     aws cognito-idp admin-create-user --user-pool-id ${aws_cognito_user_pool._.id} --username Santiago --user-attributes Name=custom:type,Value=ops --region ${var.region}
     aws cognito-idp admin-create-user --user-pool-id ${aws_cognito_user_pool._.id} --username Felix --user-attributes Name=custom:type,Value=ops --region ${var.region}
     aws cognito-idp admin-create-user --user-pool-id ${aws_cognito_user_pool._.id} --username Morgan --user-attributes Name=custom:type,Value=ops --region ${var.region}
     aws cognito-idp admin-add-user-to-group --user-pool-id ${aws_cognito_user_pool._.id} --username Eugene --group-name developers  --region ${var.region}
     aws cognito-idp admin-add-user-to-group --user-pool-id ${aws_cognito_user_pool._.id} --username Milo --group-name developers  --region ${var.region}
     aws cognito-idp admin-add-user-to-group --user-pool-id ${aws_cognito_user_pool._.id} --username Abigail --group-name developers  --region ${var.region}
     aws cognito-idp admin-add-user-to-group --user-pool-id ${aws_cognito_user_pool._.id} --username Aidan --group-name developers  --region ${var.region}
     aws cognito-idp admin-add-user-to-group --user-pool-id ${aws_cognito_user_pool._.id} --username Santiago --group-name operations --region ${var.region}
     aws cognito-idp admin-add-user-to-group --user-pool-id ${aws_cognito_user_pool._.id} --username Felix --group-name operations --region ${var.region}
     aws cognito-idp admin-add-user-to-group --user-pool-id ${aws_cognito_user_pool._.id} --username Morgan --group-name operations --region ${var.region}

    EOT
  }
}


# aws_iam_role.cognito for dev
resource "aws_iam_role" "developer_role" {
  name = "developer_role"

  assume_role_policy = "${
    data.template_file.cognito_developer_assume_role.rendered
  }"
}


# aws_iam_role.cognito for ops
resource "aws_iam_role" "ops_role" {
  name = "ops_role"

  assume_role_policy = "${
    data.template_file.cognito_ops_assume_role.rendered
  }"
}
