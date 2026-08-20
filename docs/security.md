# Security

This document explains the security controls provided by the blueprint and what additional controls are expected for production.

Implemented controls (v1):

- Non-root container user
- Read-only root filesystem where practical
- Dropped Linux capabilities (drop: ["ALL"]) for the container
- Seccomp profile: RuntimeDefault
- Pod liveness/readiness probes
- Minimal resource requests and limits
- No embedded credentials or secrets in the repository; examples use placeholders
- CI pipeline includes Trivy scans and SBOM generation

Controls to add in production:

- Private endpoints for ACR and Key Vault
- Network isolation and NSGs
- Centralised secrets/rotation policies
- Policy enforcement (e.g., Azure Policy, Kyverno)
- Container image signing and attestation (Cosign/SLSA)

Notes:
- The Terraform examples do not provision network controls or private endpoints — these are out of scope for the reference blueprint.
