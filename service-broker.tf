#
# Vault service broker server
#

resource "cf_route" "vault-broker" {
  domain   = "${data.cf_domain.root-domain.id}"
  space    = "${data.cf_space.vault-broker-target.id}"
  hostname = "vault-broker-${var.route_postfix}"
}

resource cf_app "vault-broker" {
  name  = "vault-service-broker"
  space = "${data.cf_space.vault-broker-target.id}"

  instances  = "${var.num_server_instances}"
  memory     = "256"
  disk_quota = "512"

  timeout = "600"

  command = "cf-vault-service-broker"

  git {
    url = "https://github.com/hashicorp/vault-service-broker.git"
    tag = "${var.vault_service_broker_version}"
  }

  add_content {
    source      = "${var.ca_cert_path}"
    destination = "root_ca.pem"
  }

  route {
    default_route = "${cf_route.vault-broker.id}"
  }

  environment {
    GOVERSION              = "go1.7"
    GOPACKAGENAME          = "github.com/hashicorp/cf-vault-service-broker"
    VAULT_ADDR             = "${var.vault_address}"
    VAULT_TOKEN            = "${data.external.vault-broker-token.result["token"]}"
    VAULT_CACERT           = "root_ca.pem"
    SECURITY_USER_NAME     = "${var.service_broker_username}"
    SECURITY_USER_PASSWORD = "${var.service_broker_password}"
  }
}
