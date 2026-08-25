# ADR 0003: GitOps deployment authority

## Status
Accepted

## Context
The blueprint needs deterministic environment state reconciliation and drift correction.

## Decision
Argo CD Applications in [gitops/argocd/applications/](../../gitops/argocd/applications/) are the deployment authority for dev and prod. Automated sync, prune, and self-heal are enabled.

## Consequences
- Git is the source of truth for Kubernetes workload desired state.
- Manual in-cluster edits are intentionally overwritten by reconciliation.
