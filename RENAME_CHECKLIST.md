# Breakwater GitHub Rename Checklist (Owner-Only)

1. Rename repository slug from `secure-aks-service-blueprint` to `breakwater` in GitHub settings.
2. Confirm redirect from old repository URL works.
3. Update local `origin` URL after rename:
   - `git remote -v`
   - `git remote set-url origin <new-breakwater-url>`
4. Verify Argo CD repo references are reachable from the renamed repository:
   - `gitops/argocd/applications/secure-service-dev.yaml`
   - `gitops/argocd/applications/secure-service-prod.yaml`
5. Push validated changes and confirm CI is green on renamed repo.
6. Tag `v1.0.0` and publish release notes.
