# GitOps environments

Environment-specific Argo CD applications are defined in [argocd/applications/](./argocd/applications/):

- [secure-service-dev.yaml](./argocd/applications/secure-service-dev.yaml)
- [secure-service-prod.yaml](./argocd/applications/secure-service-prod.yaml)

Each application references Helm values in [values/](./values/):

- [dev.yaml](./values/dev.yaml)
- [prod.yaml](./values/prod.yaml)

Both environments are configured for automated sync with prune and self-heal enabled.
