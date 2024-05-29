locals {
  admin_username = (var.admin_username != "" ? var.admin_username : random_string.username.result)
  admin_password = (var.admin_password != "" ? var.admin_password : try(random_password.password[0].result, ""))
}