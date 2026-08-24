# Deployment

This section describes how to deploy the blueprint to Azure for testing. The repository is designed to be understandable without creating cloud resources.

Quick notes:

- Terraform is environment-composed under [infra/terraform/environments/](/C:/Dev/secure-aks-service-blueprint/infra/terraform/environments).
- Remote state bootstrap is separated into [infra/terraform/bootstrap/remote-state](/C:/Dev/secure-aks-service-blueprint/infra/terraform/bootstrap/remote-state).
- No backend credentials or secrets are committed.

## 1) Bootstrap remote state (one-time per subscription)

```bash
cd infra/terraform/bootstrap/remote-state
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

Then copy [backend.hcl.example](/C:/Dev/secure-aks-service-blueprint/infra/terraform/environments/dev/backend.hcl.example) or [backend.hcl.example](/C:/Dev/secure-aks-service-blueprint/infra/terraform/environments/prod/backend.hcl.example) to `backend.hcl` and fill the storage account details from bootstrap outputs.

## 2) Environment plan/apply (example: dev)

```bash
cd infra/terraform/environments/dev
cp terraform.tfvars.example terraform.tfvars
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

## 3) Helm values wired to Terraform outputs

Use Terraform outputs to configure Helm:

- `workload_identity_client_id` -> `workloadIdentity.clientID`
- `workload_identity_service_account_name` -> `workloadIdentity.serviceAccountName`
- `acr_login_server` -> image repository prefix

Deployment via GitHub Actions should use OIDC federation (no client secret). See [.github/workflows/infra-oidc.yml](/C:/Dev/secure-aks-service-blueprint/.github/workflows/infra-oidc.yml).
