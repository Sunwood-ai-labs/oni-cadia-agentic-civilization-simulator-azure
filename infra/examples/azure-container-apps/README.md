# Sanitized Terraform Example

This is a public-safe example for explaining the Azure Container Apps topology.

It is not the live production state for ONI-CADIA.

Important:

- do not commit `terraform.tfstate`
- do not commit `terraform.tfvars`
- do not commit real Mattermost bot tokens
- do not commit real Azure OpenAI keys
- prefer remote state for real operations

For public submission, this example is enough to show how Compose-style services map to Azure Container Apps:

- Mattermost as one public Container App
- each Azure citizen as a separate Container App
- secrets injected as runtime secret references
