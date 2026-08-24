# Terraform layout (v2 phase 1)

This directory uses reusable modules and environment composition:

- `modules/`: reusable Azure resource modules
- `environments/dev` and `environments/prod`: composition roots using the same modules
- `bootstrap/remote-state`: one-time Terraform state backend bootstrap

The environment roots provision:

- Resource Group
- ACR
- AKS (OIDC issuer + Workload Identity enabled)
- Key Vault (RBAC-enabled)
- User Assigned Managed Identity + federated identity credential
- Least-privilege role assignments:
  - `AcrPull` for AKS kubelet identity on ACR
  - `Key Vault Secrets User` for workload identity UAMI on Key Vault

