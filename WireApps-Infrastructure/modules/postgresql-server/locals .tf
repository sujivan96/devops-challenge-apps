locals {
  admin_password = try(random_password.password[0].result, "")
}