# Breakwater v1.0 Release Readiness

## Scope

Final validation/polish pass for the existing blueprint (no new feature phase).

## Repository reality check

Validated implementation surfaces:

- Terraform modules and environment composition for AKS/ACR/Key Vault/identity.
- AKS OIDC + Workload Identity + federated credential subject contract.
- Key Vault RBAC + ACR `AcrPull` role assignments.
- Helm secure-service chart and workload identity wiring.
- Argo CD GitOps manifests for dev/prod with env-specific values.
- Kyverno baseline/supply-chain/workload-contract policies with positive and negative fixtures.
- Trivy gates for IaC/filesystem/image and SBOM generation.
- Prometheus SLO rules and burn-rate tests.
- CI workflows for app quality, infra linting, policy gates, SRE checks, and OIDC infra plan/apply flow.

## Implementation vs documentation discrepancies found/resolved

- Project branding renamed to **Breakwater** across code/docs/config metadata.
- Argo CD repo URLs switched to future slug `breakwater` for post-rename readiness.
- Docker build context hardened to exclude nested Terraform init artifacts (`**/.terraform*`) that were creating false-positive image scan failures in local validation.
- Vulnerability exception lists refreshed for newly surfaced base-image CVEs under existing grouped-governance model.

## Local validation commands executed

- `python -m ruff check .`
- `python -m pytest -q`
- `python scripts/validate_vulnerability_exceptions.py`
- `docker run --rm -v ${PWD}:/work -w /work hashicorp/terraform:1.9.8 -chdir=infra/terraform fmt -check -recursive`
- `docker run --rm -v ${PWD}:/work -w /work hashicorp/terraform:1.9.8 -chdir=infra/terraform/environments/dev init -backend=false`
- `docker run --rm -v ${PWD}:/work -w /work hashicorp/terraform:1.9.8 -chdir=infra/terraform/environments/dev validate`
- `docker run --rm -v ${PWD}:/work -w /work hashicorp/terraform:1.9.8 -chdir=infra/terraform/environments/prod init -backend=false`
- `docker run --rm -v ${PWD}:/work -w /work hashicorp/terraform:1.9.8 -chdir=infra/terraform/environments/prod validate`
- `docker run --rm --entrypoint sh -v ${PWD}:/work -w /work ghcr.io/terraform-linters/tflint:v0.54.0 -c "tflint --chdir=infra/terraform/environments/dev --init --config=../../.tflint.hcl && tflint --chdir=infra/terraform/environments/dev --config=../../.tflint.hcl"`
- `docker run --rm --entrypoint sh -v ${PWD}:/work -w /work ghcr.io/terraform-linters/tflint:v0.54.0 -c "tflint --chdir=infra/terraform/environments/prod --init --config=../../.tflint.hcl && tflint --chdir=infra/terraform/environments/prod --config=../../.tflint.hcl"`
- `docker run --rm -v ${PWD}:/work -w /work alpine/helm:3.16.3 lint helm/secure-service`
- `docker run --rm -v ${PWD}:/work -w /work alpine/helm:3.16.3 template secure-service helm/secure-service -f gitops/values/dev.yaml`
- `docker run --rm -v ${PWD}:/work -w /work alpine/helm:3.16.3 template secure-service helm/secure-service -f gitops/values/prod.yaml`
- `docker run --rm -v ${PWD}:/work -w /work ghcr.io/kyverno/kyverno-cli:v1.12.6 test platform/policies/tests`
- `docker run --rm --entrypoint promtool -v ${PWD}:/work -w /work prom/prometheus:v2.55.0 check rules platform/sre/prometheus/slo-rules.yaml`
- `docker run --rm --entrypoint promtool -v ${PWD}:/work -w /work prom/prometheus:v2.55.0 test rules platform/sre/prometheus/slo-alert-tests.yaml`
- `docker run --rm -v ${PWD}:/work -w /work ghcr.io/yannh/kubeconform:v0.6.7 -strict -ignore-missing-schemas gitops/argocd/applications/secure-service-dev.yaml gitops/argocd/applications/secure-service-prod.yaml`
- `docker build -t secure-aks-service:ci .`
- `docker run --rm -v ${PWD}:/work -w /work aquasec/trivy:0.57.1 config --exit-code 1 --severity HIGH,CRITICAL infra/terraform`
- `docker run --rm -v ${PWD}:/work -w /work aquasec/trivy:0.57.1 fs --exit-code 1 --severity HIGH,CRITICAL --ignorefile .trivyignore .`
- `docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v ${PWD}:/work -w /work aquasec/trivy:0.57.1 image --exit-code 1 --severity HIGH,CRITICAL --ignorefile .trivyignore secure-aks-service:ci`
- `docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v ${PWD}:/work -w /work aquasec/trivy:0.57.1 image --format cyclonedx -o /work/sbom.xml secure-aks-service:ci`

## Actual results

- Ruff: pass.
- Python tests: 4 passed (warnings only).
- Terraform fmt/init/validate (dev+prod): pass.
- TFLint (dev+prod): pass.
- Helm lint/template (dev+prod): pass.
- Kyverno tests: 17 pass / 0 fail.
- Prometheus `promtool` checks/tests: pass.
- Kubeconform for Argo CD Application manifests: pass.
- Trivy config/filesystem/image blocking checks: pass after exception refresh.
- SBOM generation: pass.

## Validation status matrix

- STATIC REPOSITORY VALIDATION: **VALIDATED**
- CI VALIDATION (workflow logic/actions/permissions): **VALIDATED STATICALLY**
- TERRAFORM PLAN VALIDATION (live Azure plan): **NOT VALIDATED IN THIS PASS**
- LIVE AZURE VALIDATION: **NOT VALIDATED IN THIS PASS**
- LIVE AKS VALIDATION: **NOT VALIDATED IN THIS PASS**
- ARGO CD LIVE VALIDATION: **NOT VALIDATED IN THIS PASS**
- WORKLOAD IDENTITY -> KEY VAULT LIVE VALIDATION: **NOT VALIDATED IN THIS PASS**
- KYVERNO LIVE VALIDATION: **NOT VALIDATED IN THIS PASS** (policy tests validated locally)
- PROMETHEUS/SLO LIVE VALIDATION: **NOT VALIDATED IN THIS PASS** (rule/test syntax validated locally)

## Security/publication audit

- No obvious committed credentials/private keys/tokens detected in working-tree scans.
- No `.tfstate` or `.tfplan` files detected.
- No `.env` files detected.
- Tenant/subscription references are variable placeholders or workflow variable names, not concrete secrets.

## Remaining old-name references

- No remaining occurrences of `Secure AKS Service Blueprint` or `secure-aks-service-blueprint` in implementation/config paths.
- Historical mention is only expected in owner process context when performing repository rename externally.

## Portfolio evidence checklist

- Terraform fmt/init/validate output: **AVAILABLE NOW**
- CI workflow definitions and policy gates: **AVAILABLE NOW**
- Kyverno compliant/violating policy tests: **AVAILABLE NOW**
- Trivy gate + SBOM generation: **AVAILABLE NOW**
- Prometheus SLO rule/test files: **AVAILABLE NOW**
- Argo CD manifests + environment split: **AVAILABLE NOW**
- Live OIDC -> Azure auth proof: **REQUIRES LIVE ENVIRONMENT**
- Live AKS + kubelet ACR pull proof: **REQUIRES LIVE ENVIRONMENT**
- Live Workload Identity -> Key Vault read proof: **REQUIRES LIVE ENVIRONMENT**
- Live Argo sync status evidence: **REQUIRES LIVE ENVIRONMENT**

## Issues

### BLOCKER

- None identified in static/local validation scope.

### SHOULD FIX

- After repo slug rename, run CI once on GitHub and confirm all jobs pass under renamed repository context.

### POLISH

- Optional: migrate `@app.on_event` FastAPI lifecycle handlers to lifespan APIs to remove deprecation warnings.

## Owner manual actions required

1. Perform GitHub repository rename (see `RENAME_CHECKLIST.md`).
2. Push these local changes and confirm first CI run in renamed repo.
3. Execute optional live-cloud acceptance checklist (OIDC plan/apply, AKS, ACR pull, Workload Identity + Key Vault).
4. Tag and release `v1.0.0`.

CONDITIONALLY READY
