#
# Generates or retrieves the Vault token for the service broker
#

data "external" "vault-broker-token" {
  program = ["${path.module}/vault-token.sh",
    "${var.vault_address}",
    "${var.ca_cert_path}",
    "${var.vault_token_policy_name}",
    "${var.vault_token_period}",
    "${var.vault_token_path}",
  ]
}

resource "vault_generic_secret" "cf-broker-token" {
  path      = "${var.vault_token_path}"
  data_json = "${jsonencode(data.external.vault-broker-token.result)}"
}
