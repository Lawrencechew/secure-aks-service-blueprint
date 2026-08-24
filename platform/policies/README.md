# Kyverno policy guardrails

Policy packs are organized by concern:

- `baseline/`: pod and container runtime hardening requirements
- `supply-chain/`: image source and tagging constraints
- `workload-contract/`: workload metadata and health-contract requirements

All policies use explicit platform namespace exclusions (`kube-system`, `kyverno`) to avoid broad user-controlled bypass patterns.

