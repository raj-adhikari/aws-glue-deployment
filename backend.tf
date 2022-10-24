# --- root/backend.tf ---

terraform {
  backend "s3" {
    bucket = "glue-deployment-project-6587"
    key    = "remote.tfstate"
    region = "us-east-1"
  }
}
