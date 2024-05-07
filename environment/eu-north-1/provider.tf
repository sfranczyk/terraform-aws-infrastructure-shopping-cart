provider "aws" {
  region  = "eu-north-1"
  profile = "dolittle"

  default_tags {
    tags = {
      "TerraformTraining" = "true"
    }
  }
}