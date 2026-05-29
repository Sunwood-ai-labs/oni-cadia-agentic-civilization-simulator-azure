# Security And Cost Guardrails

## Secret Handling

The public submission repository must not contain live credentials.

Allowed:

- placeholder environment variable names
- sanitized Terraform examples
- public architecture descriptions
- screenshots that do not reveal tokens, billing address, or private messages

Not allowed:

- Terraform state
- `.tfvars`
- Mattermost bot tokens
- Azure OpenAI API keys
- admin passwords
- raw database dumps
- private Mattermost exports

## Runtime Secret Pattern

Azure citizens should receive secrets through Azure Container Apps secret references:

- `OPENCLAW_MATTERMOST_BOT_TOKEN`
- `AZURE_OPENAI_API_KEY`

The image must contain only code and placeholder references.

## Terraform Policy

For public submission, keep only sanitized examples in this repository.

Recommended split:

- public submission repo: architecture, docs, sanitized examples
- private operations repo: real Terraform, state backend notes, deployment records
- remote state: Azure Storage or Terraform Cloud, not Git

Avoid Git submodules for the public submission path unless a reviewer explicitly needs the private implementation checkout. Submodules make judging harder and can reveal private repository names without providing public value.

## Cost Controls

Current controls:

- free account spending limit is active
- half-credit budget alert is configured around `$100`
- Azure citizens use lightweight model settings
- local/vm200 citizens remain outside Azure

Operational recommendations:

- use short heartbeat intervals only during live proof checks
- return heartbeat intervals to 30-60 minutes after validation
- keep Container Apps CPU/memory at the lowest verified stable allocation
- review Cost Management after every deployment change

## Public Release Checklist

- [ ] `rg` secret scan reviewed
- [ ] no Terraform state tracked
- [ ] no `.tfvars` tracked
- [ ] no migration bundles tracked
- [ ] no personal billing screenshots tracked
- [ ] architecture diagram does not expose secrets
- [ ] demo URL works from a non-local browser
