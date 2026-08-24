# Architecture

This repository provides a compact reference architecture for deploying a small, secure service to Azure Kubernetes Service (AKS).

High-level components:

- Developer -> GitHub -> GitHub Actions (CI)
- Container image pushed to Azure Container Registry (ACR)
- AKS cluster running the service
- Workload identity links Kubernetes ServiceAccount -> Azure managed identity
- Azure Key Vault optionally used via Secrets Store CSI Driver
- Observability via Prometheus-compatible `/metrics` and optional OpenTelemetry export

Terraform v2 structure:

- [infra/terraform/modules/resource-group](/C:/Dev/secure-aks-service-blueprint/infra/terraform/modules/resource-group)
- [infra/terraform/modules/acr](/C:/Dev/secure-aks-service-blueprint/infra/terraform/modules/acr)
- [infra/terraform/modules/aks](/C:/Dev/secure-aks-service-blueprint/infra/terraform/modules/aks)
- [infra/terraform/modules/key-vault](/C:/Dev/secure-aks-service-blueprint/infra/terraform/modules/key-vault)
- [infra/terraform/modules/identity](/C:/Dev/secure-aks-service-blueprint/infra/terraform/modules/identity)
- [infra/terraform/environments/dev](/C:/Dev/secure-aks-service-blueprint/infra/terraform/environments/dev) and [infra/terraform/environments/prod](/C:/Dev/secure-aks-service-blueprint/infra/terraform/environments/prod) compose the same modules with environment-specific sizing/names/tags.

Workload identity and RBAC path:

- AKS OIDC issuer enabled
- Federated identity credential subject: `system:serviceaccount:<namespace>:<serviceAccountName>`
- Federated identity credential attached to UAMI
- UAMI granted `Key Vault Secrets User` on Key Vault
- AKS kubelet identity granted `AcrPull` on ACR

Design notes:

- Networking and enterprise controls are intentionally minimal to keep the reference focused on workload identity, secrets integration, CI/CD and supply-chain controls.
- Real deployments should add network isolation, private endpoints, and additional policy controls as required by your organisation.
