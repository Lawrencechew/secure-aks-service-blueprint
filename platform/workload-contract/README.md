# Secure workload contract (Phase 2)

This contract defines what application workloads must provide to run on this AKS blueprint and what the platform enforces regardless of deployment source.

## What application teams must provide

- Images from the approved registry namespace (default policy value: `example.azurecr.io`)
- Non-`latest` immutable image tags
- Pod/container security context:
  - `runAsNonRoot: true`
  - `allowPrivilegeEscalation: false`
  - `readOnlyRootFilesystem: true`
  - `capabilities.drop` includes `ALL`
- Resource requests and limits for CPU and memory
- Ownership labels:
  - `platform.secure-aks.io/service`
  - `platform.secure-aks.io/owner`
  - `platform.secure-aks.io/environment`
- `serviceAccountName` set for workload identity alignment
- Readiness and liveness probes for long-running workloads (Deployment/StatefulSet/DaemonSet)

## What the platform guarantees

- Privileged pods are rejected.
- Host namespace/hostPath bypass patterns are rejected.
- Insecure or non-conformant workload specs are blocked before admission.
- Guardrails apply to both `containers` and `initContainers`.

## What gets rejected

- Privileged containers
- `:latest` image tags
- Unapproved registries
- Missing CPU/memory requests/limits
- hostNetwork/hostPID/hostIPC usage
- hostPath volumes
- Missing workload ownership labels
- Missing secure container securityContext settings

## Approved registry expectations

The supply-chain policy currently uses a non-secret default (`example.azurecr.io`) to keep local/CI testing deterministic. Environments should set the approved registry value to the target ACR pattern before deployment.

## Workload identity expectations

Workloads must provide a stable `serviceAccountName` to bind Kubernetes identity to the User Assigned Managed Identity configured by Terraform (Phase 1). This contract does not require live Azure credentials during local policy testing.

## Exception handling philosophy

No user-controlled blanket bypass label exists. Only explicit platform namespace exclusions are allowed for core system namespaces (`kube-system`, `kyverno`).

