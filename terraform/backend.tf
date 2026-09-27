terraform {
  backend "s3" {
    bucket       = "amma-pickles-terraform-state-206632868064"
    key          = "amma-pickles/terraform.tfstate"
    region       = "ap-northeast-1"
    use_lockfile = true
    encrypt      = true
  }
}
