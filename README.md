# Vault Service Broker

## Overview

This [Terraform](https://www.terraform.io/) module deploys [HashiCorp Vault service broker](https://github.com/hashicorp/vault) to a target Cloud Foundry. It requires the [Cloud Foundry Terraform provider](https://github.com/mevansam/terraform-provider-cloudfoundry).

> The Cloud Foundry provider is not available as a default Terraform provider so it needs to be installed by downloading the Cloud Foundry provider release from its GitHub repository.

## Usage

To use this module use the following HCL snippet as an example. 

```
#
# Vault Service Broker Deployment
#

module "vault-service-broker-common" {
  source = "../../../../community/terraform/modules/vault-service-broker-terraform"

  org_name   = "engineering"
  space_name = "utilities"

  vault_address = "https://vault.acme.io"

  vault_token_policy_name = "${var.vault_broker_token_policy_name}"
  vault_token_path        = "${var.vault_broker_token_path}"

  root_domain_name = "apps.acme.io"
  route_postfix    = "common"

  service_access_orgs = ["engineering"]
}

```

The following variables are supported.

* org_name - (Type: String) The organization to which the Vault service broker should be deployed to.

* space_name - (Type: String) The space to which the Vault service broker should be deployed to.

* vault_address - (Type: String) The Vault endpoint address.

* ca_cert_path - (Type: String) "The path to CA cert for Vault if locally or self-signed. Default is 'N/A', which will require the Vault endpoint to have a valid certificate if using HTTPS.

* vault_token_path - (Type: String) The path to the Vault service broker token secret in Vault.

* svault_token_policy_name - (Type: String) The Vault policy to apply to the token created for the service broker.

* svault_token_period - (Type: String) The renewal period for the generated token. Default is 30 minutes.

* svault_service_broker_version - (Type: String) The Github tag of the service broker release. Default is v0.2.0.

* sservice_broker_username - (Type: String) The Github tag of the service broker release. Default is 'vault'.

* sservice_broker_password - (Type: String) The Github tag of the service broker release. Default is a random string.

* num_server_instances - (Type: Number) Number of service instances to start. The default is 1.

* root_domain_name - (Type: String) The root domain to use when mapping routes.

* route_postfix - (Type: String) A name to postfix the server hostname with to create a unique route to the Spring Cloud Data Flow server.
