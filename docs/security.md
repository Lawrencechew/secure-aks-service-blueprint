# Security

This document explains the security controls provided by the blueprint and what additional controls are expected for production.

Implemented controls (v1):

- Non-root container user
- Read-only root filesystem where practical
- Dropped Linux capabilities (drop: ["ALL"]) for the container
- Seccomp profile: RuntimeDefault
- Pod liveness/readiness probes
- Minimal resource requests and limits
- No embedded credentials or secrets in the repository; examples use placeholders
- CI pipeline includes Trivy scans and SBOM generation

Implemented controls (v2 phase 1 IaC):

- AKS OIDC issuer + Workload Identity enabled in Terraform
- Federated identity credential from AKS ServiceAccount subject to User Assigned Managed Identity
- Key Vault configured for Azure RBAC data-plane authorization
- Least-privilege RBAC:
  - `AcrPull` for AKS kubelet identity on ACR scope
  - `Key Vault Secrets User` for secure-service UAMI on Key Vault scope
- Infrastructure CI includes blocking `terraform validate`, `tflint`, `trivy config`, and `helm lint`
- GitHub Actions -> Azure authentication design uses OIDC federation (no stored client secret)

Controls to add in production:

- Private endpoints for ACR and Key Vault
- Network isolation and NSGs
- Centralised secrets/rotation policies
- Policy enforcement (e.g., Azure Policy, Kyverno)
- Container image signing and attestation (Cosign/SLSA)

Notes:
- The Terraform examples do not provision network controls or private endpoints — these are out of scope for the reference blueprint.
- Live Azure apply remains a protected/manual step in [.github/workflows/infra-oidc.yml](/C:/Dev/secure-aks-service-blueprint/.github/workflows/infra-oidc.yml).
