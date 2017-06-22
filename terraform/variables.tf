# variables shared by all environments

provider "aws" {
  region = "eu-west-1"
  assume_role {
    role_arn = "arn:aws:iam::536099501702:role/admin"
  }
}

variable "tf_s3_bucket" {
  default = "informatics-timewatch-terraform"
}

variable "dev_state_file" {
  default = "timewatch/dev/dev.tfstate"
}
