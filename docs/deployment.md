# Deployment

This section describes how to deploy the blueprint to Azure for testing. The repository is designed to be understandable without creating cloud resources.

Quick notes:

- Terraform variables are intentionally empty for tenant/subscription/resource names. Set values in `infra/terraform/terraform.tfvars` or pass them in CI securely.
- The repository includes an example Terraform layout intended for demonstration only. Production deployments require additional controls.

Example local terraform workflow (requires Azure CLI auth):

```bash
cd infra/terraform
terraform init
terraform plan -var="acr_name=myacr" -var="aks_cluster_name=myaks" -var="key_vault_name=mykv"
terraform apply -var="acr_name=myacr" -var="aks_cluster_name=myaks" -var="key_vault_name=mykv"
```

Deployment via GitHub Actions should use OIDC/federated credentials; see `docs/security.md` and the README for guidance.
