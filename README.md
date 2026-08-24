# secure-aks-service-blueprint

Production-oriented AKS service blueprint demonstrating secure CI/CD, workload identity, observability and software supply-chain practices.

## Terraform v2 (Phase 1)

Infrastructure code is organized under [infra/terraform/](/C:/Dev/secure-aks-service-blueprint/infra/terraform):

- Reusable modules: [modules/](/C:/Dev/secure-aks-service-blueprint/infra/terraform/modules)
- Environment composition roots: [environments/dev](/C:/Dev/secure-aks-service-blueprint/infra/terraform/environments/dev), [environments/prod](/C:/Dev/secure-aks-service-blueprint/infra/terraform/environments/prod)
- Remote-state bootstrap: [bootstrap/remote-state](/C:/Dev/secure-aks-service-blueprint/infra/terraform/bootstrap/remote-state)

Each environment composes the same modules for:

- Resource Group
- ACR
- AKS (OIDC issuer + Workload Identity enabled)
- Key Vault
- User Assigned Managed Identity + federated identity credential
- Azure RBAC assignments for AcrPull and Key Vault secret reads

## Workload Identity wiring

Terraform federates a Kubernetes ServiceAccount subject:

`system:serviceaccount:<namespace>:<serviceAccountName>`

with the User Assigned Managed Identity. Keep Helm and Terraform aligned by setting:

- Terraform: `k8s_namespace`, `k8s_service_account_name`
- Helm: `workloadIdentity.enabled=true`, `workloadIdentity.serviceAccountName=<same-name>`, `workloadIdentity.clientID=<terraform output>`

## CI and infrastructure validation

[.github/workflows/ci.yml](/C:/Dev/secure-aks-service-blueprint/.github/workflows/ci.yml) runs blocking checks for:

- `terraform fmt -check`
- `terraform init -backend=false`
- `terraform validate`
- `tflint`
- `trivy config`
- `helm lint`

The OIDC plan/apply design is implemented in [.github/workflows/infra-oidc.yml](/C:/Dev/secure-aks-service-blueprint/.github/workflows/infra-oidc.yml):

- Pull requests: OIDC-authenticated Terraform `plan`
- Manual/protected execution: Terraform `apply` via `workflow_dispatch`

See [docs/deployment.md](/C:/Dev/secure-aks-service-blueprint/docs/deployment.md) and [docs/security.md](/C:/Dev/secure-aks-service-blueprint/docs/security.md) for run procedures and security details.
