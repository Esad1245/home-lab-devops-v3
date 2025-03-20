variable "azure_subscription_id" {
  description = "The subscription ID for Azure"
  type        = string
}

variable "azure_client_id" {
  description = "The client ID for Azure"
  type        = string
}

variable "azure_client_secret" {
  description = "The client secret for Azure"
  type        = string
  sensitive   = true
}

variable "azure_tenant_id" {
  description = "The tenant ID for Azure"
  type        = string
}