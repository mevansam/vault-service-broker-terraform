#
# Module inputs
#

variable "org_name" {
  description = "The organization to which the Vault service broker should be deployed to."
  type        = "string"
}

variable "space_name" {
  description = "The space to which the Vault service broker should be deployed to."
  type        = "string"
}

variable "vault_address" {
  description = "The Vault endpoint address."
  type        = "string"
}

variable "ca_cert_path" {
  description = "The path to CA cert for Vault if locally or self-signed."
  default     = "N/A"
}

variable "vault_token_path" {
  description = "The path to the Vault service broker token secret in Vault."
}

variable "vault_token_policy_name" {
  description = "The Vault policy to apply to the token created for the service broker."
  type        = "string"
}

variable "vault_token_period" {
  description = "The renewal period for the generated token."
  default     = "30m"
}

variable "vault_service_broker_version" {
  description = "The Github tag of the service broker release."
  default     = "v0.2.0"
}

variable "service_broker_username" {
  default = "vault"
}

variable "service_broker_password" {
  default = "GW3QQKF5ygsW83BTSfjghWQbBx6CJJU6"
}

variable "num_server_instances" {
  default = 1
}

variable "root_domain_name" {
  description = "The root domain to use when mapping routes."
  type        = "string"
}

variable "route_postfix" {
  description = "A name to postfix the server hostname with to create a unique route to the Vault service broker."
}

variable "service_access_orgs" {
  description = "Orgs which will be granted access tothe service broker."
  type        = "list"
}
