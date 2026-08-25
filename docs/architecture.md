# Architecture

This repository provides a compact reference architecture for deploying a small, secure service to Azure Kubernetes Service (AKS).

High-level components:

- Developer -> GitHub -> GitHub Actions (CI)
- Container image pushed to Azure Container Registry (ACR)
- AKS cluster running the service
- Workload identity links Kubernetes ServiceAccount -> Azure managed identity
- Azure Key Vault optionally used via Secrets Store CSI Driver
- Observability via Prometheus-compatible `/metrics` and optional OpenTelemetry export
- GitOps deployment intent via Argo CD Application manifests per environment

Terraform v2 structure:

- [infra/terraform/modules/resource-group](../infra/terraform/modules/resource-group)
- [infra/terraform/modules/acr](../infra/terraform/modules/acr)
- [infra/terraform/modules/aks](../infra/terraform/modules/aks)
- [infra/terraform/modules/key-vault](../infra/terraform/modules/key-vault)
- [infra/terraform/modules/identity](../infra/terraform/modules/identity)
- [infra/terraform/environments/dev](../infra/terraform/environments/dev) and [infra/terraform/environments/prod](../infra/terraform/environments/prod) compose the same modules with environment-specific sizing/names/tags.

GitOps environment split:

- [gitops/argocd/applications/secure-service-dev.yaml](../gitops/argocd/applications/secure-service-dev.yaml)
- [gitops/argocd/applications/secure-service-prod.yaml](../gitops/argocd/applications/secure-service-prod.yaml)
- [gitops/values/dev.yaml](../gitops/values/dev.yaml)
- [gitops/values/prod.yaml](../gitops/values/prod.yaml)

Workload identity and RBAC path:

- AKS OIDC issuer enabled
- Federated identity credential subject: `system:serviceaccount:<namespace>:<serviceAccountName>`
- Federated identity credential attached to UAMI
- UAMI granted `Key Vault Secrets User` on Key Vault
- AKS kubelet identity granted `AcrPull` on ACR

Design notes:

- Networking and enterprise controls are intentionally minimal to keep the reference focused on workload identity, secrets integration, CI/CD and supply-chain controls.
- Real deployments should add network isolation, private endpoints, and additional policy controls as required by your organisation.
- Monitoring integration resources (ServiceMonitor/PrometheusRule) are rendered through the Helm chart and expected to be reconciled through GitOps.
- Helm supports immutable image references through `image.digest` (repository@sha256 form), used by GitOps environment values for production-style promotion.
