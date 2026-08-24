# ADR 0001: Terraform and Helm ownership boundary

## Status
Accepted

## Context
The platform provisions cloud primitives and identity, while application teams deploy workload manifests.

## Decision
Terraform owns Azure infrastructure and identity/RBAC configuration. Helm owns Kubernetes workload runtime configuration and pod-level controls. Argo CD applies Helm state.

## Consequences
- Clear separation of concerns for platform and app operations.
- Terraform outputs must map cleanly into Helm values (for example workload identity client IDs and image registry endpoints).
