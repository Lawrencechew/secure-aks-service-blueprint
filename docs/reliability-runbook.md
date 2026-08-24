# Reliability runbook — secure-service SLO alerts

This runbook maps SLO burn-rate alerts to triage and recovery actions.

## Alert: SecureServiceErrorBudgetFastBurn (critical)

Meaning:

- severe short-term and medium-window error budget burn

SLO linkage:

- availability SLO 99.9%, error budget ratio 0.001

Immediate checks:

1. `secure_service:error_budget_burn_rate:5m`
2. `secure_service:error_budget_burn_rate:30m`
3. `secure_service:error_ratio:5m`
4. `secure_service:request_rate:5m`

Application checks:

- `/health`
- `/ready`
- inspect recent `request.end` logs for rising 5xx

Kubernetes checks:

- pod restarts / CrashLoopBackOff
- Deployment rollout status
- failing probes / readiness drops

Argo CD / GitOps checks:

- app sync/health status
- recent sync operation and revision
- identify any just-applied desired-state change

Recovery path:

1. If caused by recent desired-state change, revert in Git.
2. Let Argo reconcile to known-good commit.
3. Confirm pods become Ready and 5xx ratio drops.

Recovery indicators:

- burn-rate recording rules decline below thresholds
- alert clears
- readiness and request success normalize

## Alert: SecureServiceErrorBudgetSlowBurn (warning)

Meaning:

- sustained error-budget consumption over longer windows

SLO linkage:

- same availability error-budget model

Checks:

1. Compare 30m vs 2h burn rates for trend direction.
2. Check gradual dependency degradations, timeout regressions, and rollout side effects.
3. Inspect any non-critical but persistent 5xx patterns by endpoint.

Recovery:

- prioritize controlled rollback of suspect changes or dependency stabilization
- track burn-rate trend to ensure it decays instead of flatlining high

