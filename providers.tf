provider "aws" {
  region = tolist(var.regions)[0]
}