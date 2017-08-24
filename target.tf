#
# The target org and space to deploy the Vault service broker to
#

data "cf_info" "info" {}

data "cf_domain" "root-domain" {
  name = "${var.root_domain_name}"
}

data "cf_space" "vault-broker-target" {
  name     = "${var.space_name}"
  org_name = "${var.org_name}"
}
