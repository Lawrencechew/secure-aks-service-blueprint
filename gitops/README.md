# GitOps environments

Environment-specific Argo CD applications are defined in [argocd/applications/](/C:/Dev/secure-aks-service-blueprint/gitops/argocd/applications):

- [secure-service-dev.yaml](/C:/Dev/secure-aks-service-blueprint/gitops/argocd/applications/secure-service-dev.yaml)
- [secure-service-prod.yaml](/C:/Dev/secure-aks-service-blueprint/gitops/argocd/applications/secure-service-prod.yaml)

Each application references Helm values in [values/](/C:/Dev/secure-aks-service-blueprint/gitops/values):

- [dev.yaml](/C:/Dev/secure-aks-service-blueprint/gitops/values/dev.yaml)
- [prod.yaml](/C:/Dev/secure-aks-service-blueprint/gitops/values/prod.yaml)

Both environments are configured for automated sync with prune and self-heal enabled.
