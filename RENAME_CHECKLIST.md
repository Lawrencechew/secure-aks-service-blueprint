# Breakwater GitHub Rename Checklist (Completed)

Completed actions:

1. Renamed repository slug from `secure-aks-service-blueprint` to `breakwater`.
2. Confirmed redirect from the old repository URL.
3. Updated local `origin` URL:
   - `git remote -v`
   - `git remote set-url origin https://github.com/Lawrencechew/breakwater.git`
4. Verified Argo CD repo references remain reachable from the renamed repository:
   - `gitops/argocd/applications/secure-service-dev.yaml`
   - `gitops/argocd/applications/secure-service-prod.yaml`
5. Pushed validated changes and confirmed CI is green on the renamed repo.

Remaining owner release step:

- Tag `v1.0.0` and publish release notes.
