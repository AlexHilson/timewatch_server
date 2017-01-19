# variables shared by all environments

provider "aws" {
  region = "eu-west-1"
}

variable "tf_s3_bucket" {
  default = "informatics-timewatch-terraform"
}

variable "dev_state_file" {
  default = "timewatch/dev/dev.tfstate"
}
