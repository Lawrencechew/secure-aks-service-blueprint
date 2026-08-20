# Architecture

This repository provides a compact reference architecture for deploying a small, secure service to Azure Kubernetes Service (AKS).

High-level components:

- Developer -> GitHub -> GitHub Actions (CI)
- Container image pushed to Azure Container Registry (ACR)
- AKS cluster running the service
- Workload identity links Kubernetes ServiceAccount -> Azure managed identity
- Azure Key Vault optionally used via Secrets Store CSI Driver
- Observability via Prometheus-compatible `/metrics` and optional OpenTelemetry export

Design notes:

- Networking and enterprise controls are intentionally minimal to keep the reference focused on workload identity, secrets integration, CI/CD and supply-chain controls.
- Real deployments should add network isolation, private endpoints, and additional policy controls as required by your organisation.
