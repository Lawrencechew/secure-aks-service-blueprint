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

## Policy guardrails and workload contract (Phase 2)

Kyverno-based policy-as-code is implemented under [platform/policies/](/C:/Dev/secure-aks-service-blueprint/platform/policies):

- Baseline runtime hardening policies
- Supply-chain image policies
- Workload contract enforcement policies

Reference manifests for local policy verification are provided in:

- [examples/compliant/](/C:/Dev/secure-aks-service-blueprint/examples/compliant)
- [examples/violations/](/C:/Dev/secure-aks-service-blueprint/examples/violations)

The implementation-focused workload contract is documented at [platform/workload-contract/README.md](/C:/Dev/secure-aks-service-blueprint/platform/workload-contract/README.md).

## SRE SLIs, SLOs, and burn-rate alerting (Phase 3)

Phase 3 SRE artifacts:

- SRE model and exact SLI/SLO PromQL: [docs/sre-phase3.md](/C:/Dev/secure-aks-service-blueprint/docs/sre-phase3.md)
- Reliability runbook: [docs/reliability-runbook.md](/C:/Dev/secure-aks-service-blueprint/docs/reliability-runbook.md)
- Reliability drills and rollback model: [docs/reliability-drills.md](/C:/Dev/secure-aks-service-blueprint/docs/reliability-drills.md)
- Recording/alerting rules: [platform/sre/prometheus/slo-rules.yaml](/C:/Dev/secure-aks-service-blueprint/platform/sre/prometheus/slo-rules.yaml)
- Prometheus rule tests: [platform/sre/prometheus/slo-alert-tests.yaml](/C:/Dev/secure-aks-service-blueprint/platform/sre/prometheus/slo-alert-tests.yaml)

## Phase 4 hardening and closeout

### GitOps environment authority

- Environment applications: [gitops/argocd/applications/secure-service-dev.yaml](/C:/Dev/secure-aks-service-blueprint/gitops/argocd/applications/secure-service-dev.yaml), [gitops/argocd/applications/secure-service-prod.yaml](/C:/Dev/secure-aks-service-blueprint/gitops/argocd/applications/secure-service-prod.yaml)
- Environment values: [gitops/values/dev.yaml](/C:/Dev/secure-aks-service-blueprint/gitops/values/dev.yaml), [gitops/values/prod.yaml](/C:/Dev/secure-aks-service-blueprint/gitops/values/prod.yaml)
- Sync behavior: automated reconcile with prune + self-heal enabled.

### Supply chain policy hardening

- Blocking vulnerability gates for Trivy filesystem and image scans at HIGH/CRITICAL severity in [.github/workflows/ci.yml](/C:/Dev/secure-aks-service-blueprint/.github/workflows/ci.yml)
- SBOM generation remains a mandatory CI artifact (`sbom.xml`, CycloneDX)
- Negative gate demonstration: CI intentionally verifies that [platform/negative-tests/trivy/insecure-deployment.yaml](/C:/Dev/secure-aks-service-blueprint/platform/negative-tests/trivy/insecure-deployment.yaml) is rejected by Trivy.
- Exception mechanism:
  - Technical allowlist: [.trivyignore](/C:/Dev/secure-aks-service-blueprint/.trivyignore)
  - Review policy: [security/vulnerability-exceptions.yaml](/C:/Dev/secure-aks-service-blueprint/security/vulnerability-exceptions.yaml)

### Immutable image support

- Helm chart supports digest-pinned images (`repository@sha256:digest`) via `image.digest` in [helm/secure-service/values.yaml](/C:/Dev/secure-aks-service-blueprint/helm/secure-service/values.yaml).

### Decision records and operations guide

- ADRs: [docs/adr/](/C:/Dev/secure-aks-service-blueprint/docs/adr)
- Demo/operations flow: [docs/demo-guide.md](/C:/Dev/secure-aks-service-blueprint/docs/demo-guide.md)
