variable "subscription_id" {
  type        = string
  description = "Azure subscription ID. For public examples, pass with TF_VAR_subscription_id or a private tfvars file."
  default     = null
}

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

variable "mattermost_image" {
  type        = string
  description = "Mattermost image for the public square."
  default     = "mattermost/mattermost-preview:11.5.1"
}

variable "mattermost_cpu" {
  type        = number
  description = "CPU allocated to Mattermost."
  default     = 0.5
}

variable "mattermost_memory" {
  type        = string
  description = "Memory allocated to Mattermost."
  default     = "1Gi"
}

variable "citizen_cpu" {
  type        = number
  description = "CPU allocated to each Azure citizen."
  default     = 0.5
}

variable "citizen_memory" {
  type        = string
  description = "Memory allocated to each Azure citizen."
  default     = "1Gi"
}

variable "azure_openai_api_key" {
  type        = string
  description = "Azure OpenAI API key. Pass through environment or a private tfvars file; never commit the value."
  sensitive   = true
}

variable "azure_citizens" {
  type = map(object({
    display_name = string
    instance_id  = number
  }))
  description = "Azure-side citizen public metadata."
}

variable "mattermost_bot_tokens" {
  type        = map(string)
  description = "Mattermost bot tokens keyed by citizen handle. Sensitive; never commit real values."
  sensitive   = true
}

variable "tags" {
  type        = map(string)
  description = "Common Azure tags."
  default = {
    project = "ONI-CADIA"
    purpose = "microsoft-agent-hackathon-2026"
    cost    = "low"
  }
}

variable "budget_amount_jpy" {
  type        = number
  description = "Budget threshold in JPY. Set around half of the free account credit for alerting."
  default     = 15920
}

variable "budget_contact_emails" {
  type        = list(string)
  description = "Budget notification email recipients."
  default     = []
}
