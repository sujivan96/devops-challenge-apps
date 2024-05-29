 module "postgresel_wireapps" {
  source = "../modules/resource-group"
  name                = "devops-challenge-db-server"
  location            = module.resource_group_wireapps.location
  resource_group_name = module.resource_group_wireapps.name
  # NEED TO DIFINE OTHERS VARIABLES HERE 
 }