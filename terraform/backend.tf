terraform {
  backend "s3" {
    bucket       = "amma-pickles-terraform-state-597994428626"
    key          = "amma-pickles/terraform.tfstate"
    region       = "ap-northeast-1"
    encrypt      = true
    kms_key_id   = "arn:aws:kms:ap-northeast-1:597994428626:key/8c624857-7943-40eb-baba-ae9682e1ad4a"
    use_lockfile = true
  }
}
