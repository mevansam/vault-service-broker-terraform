#
# Register the Vault service broker and grant access to it
#

resource "cf_service_broker" "vault-broker" {
  name     = "vault-service-broker"
  url      = "https://${cf_route.vault-broker.endpoint}"
  username = "${var.service_broker_username}"
  password = "${var.service_broker_password}"
}

resource "cf_service_access" "redis-access" {
  count = "${length(var.service_access_orgs)}"

  plan = "${cf_service_broker.vault-broker.service_plans["hashicorp-vault/shared"]}"
  org  = "${var.service_access_orgs[count.index]}"
}
