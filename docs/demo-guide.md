# Demo guide

## Goal
Show the end-to-end blueprint flow with clear separation between local/static validation and live Azure execution.

## Local/static walkthrough
1. Run app quality checks (`ruff`, `pytest`).
2. Run infrastructure checks (`terraform fmt`, `terraform init -backend=false`, `terraform validate`, `tflint`, `trivy config`, `helm lint`).
3. Run policy tests (Kyverno test suite).
4. Run SRE checks (`promtool check rules`, `promtool test rules`).
5. Run build checks (`docker build`, blocking Trivy fs/image scans, SBOM generation).

## Live Azure acceptance walkthrough
1. Trigger OIDC Terraform `plan` using [infra-oidc.yml](/C:/Dev/secure-aks-service-blueprint/.github/workflows/infra-oidc.yml).
2. Trigger protected/manual `apply`.
3. Verify AKS cluster exists.
4. Verify kubelet can pull from ACR.
5. Verify pod ServiceAccount federation to UAMI and Key Vault secret read.

If required GitHub/Azure OIDC identifiers are not configured, report live gates as pending rather than claimed complete.
