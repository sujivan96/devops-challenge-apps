terraform {
  required_version = "1.5.7"

  backend "azurerm" {
    # These values will be passed in the pipeline using the --backend-config flag
  }


  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.73.0"
    }
    
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
    
    # local = {
    #   source  = "hashicorp/local"
    #   version = "2.2.3"
    # }
  }
}