# ADR 0002: Workload identity contract

## Status
Accepted

## Context
Earlier revisions had a mismatch between Kubernetes ServiceAccount naming and federated identity subject mapping.

## Decision
Treat `namespace + serviceAccountName` as a strict contract across Terraform, Helm, and runtime manifests. The canonical subject remains:
`system:serviceaccount:<namespace>:<serviceAccountName>`.

## Consequences
- Any service account rename must update Terraform environment inputs and Helm values in the same change.
- Prevents auth drift that breaks Key Vault access at runtime.
