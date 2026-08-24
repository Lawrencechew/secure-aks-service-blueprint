# Reliability drills (repeatable, safe)

These drills are designed to be run in a non-production environment.

## Scenario A — Pod loss recovery

Steps:

1. Delete one secure-service pod.
2. Observe Deployment controller replacing the pod.
3. Verify replacement pod reaches Ready.

Expected outcome:

- replica count recovers
- service remains healthy/recoverable

## Scenario B — GitOps drift correction

Steps:

1. Introduce a safe manual in-cluster drift (non-critical field).
2. Observe Argo CD marking application OutOfSync.
3. Allow reconciliation.

Expected outcome:

- Argo restores Git desired state

## Scenario C — Bad desired-state rollout and rollback

Steps:

1. Commit a controlled bad desired-state change in test env.
2. Observe unhealthy deployment signal.
3. Revert commit in Git.
4. Observe Argo reconcile to prior known-good state.

Expected outcome:

- unhealthy rollout is detectable
- Git revert restores service state

## Scenario D — Reliability signal exercise

Steps:

1. Introduce controlled request failures in test conditions.
2. Observe SLI degradation and burn-rate rise.
3. Confirm alert transition, then recover workload.

Expected outcome:

- SLI/alerts respond to real degradation
- alert clears after recovery

## Preferred rollback model

Primary rollback path is GitOps:

`bad desired state -> Git revert -> Argo reconciliation -> known-good state`

Kubernetes-native rollout tooling can assist diagnosis, but Git remains source of truth.

