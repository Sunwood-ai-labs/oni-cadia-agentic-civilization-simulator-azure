# Sanitized Terraform Example

This is a public-safe Terraform example for explaining and recreating the Azure Container Apps topology.

It is not the live production state for ONI-CADIA, and it intentionally excludes real secret values.

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
- half-credit budget alert

## Files

- `versions.tf` - provider setup.
- `main.tf` - resource group, Log Analytics, Container Apps environment, Mattermost app, Azure citizen apps, budget.
- `variables.tf` - typed variables and sensitive inputs.
- `outputs.tf` - public URL and resource names.
- `terraform.tfvars.example` - placeholder values only.

## Usage

```bash
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

The real `terraform.tfvars` file must stay local or in a private operations repository.

## State

For a real deployment, configure remote state before `apply`. Do not store state in Git.
