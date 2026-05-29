variable "resource_group_name" {
  type        = string
  description = "Resource group for the public demo."
}

variable "location" {
  type        = string
  description = "Azure region for Container Apps."
  default     = "japaneast"
}

variable "name_prefix" {
  type        = string
  description = "Resource name prefix."
  default     = "onicadia"
}

variable "openclaw_citizen_image" {
  type        = string
  description = "Public or authenticated container image for Azure citizens."
  default     = "ghcr.io/example/oni-cadia-openclaw-citizen:main"
}

variable "azure_openai_api_key" {
  type        = string
  description = "Azure OpenAI API key. Pass through environment or a private tfvars file; never commit the value."
  sensitive   = true
}

variable "azure_citizens" {
  type = map(object({
    display_name         = string
    mattermost_bot_token = string
  }))
  description = "Azure-side citizens. Tokens are sensitive and must not be committed."
  sensitive   = true
}
