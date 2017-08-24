#
# Register the Vault service broker and grant access to it
#

resource "cf_service_broker" "vault-broker" {
  name     = "vault-service-broker"
  url      = "https://${cf_route.vault-broker.endpoint}"
  username = "${var.service_broker_username}"
  password = "${var.service_broker_password}"
}

resource "cf_service_access" "vault-broker" {
  count = "${length(var.service_access_orgs)}"

  plan = "${cf_service_broker.vault-broker.service_plans["hashicorp-vault/shared"]}"
  org  = "${element(data.cf_org.vault-org.*.id, count.index)}"
}

data "cf_org" "vault-org" {
  count = "${length(var.service_access_orgs)}"
  name  = "${var.service_access_orgs[count.index]}"
}
