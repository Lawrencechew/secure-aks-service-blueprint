# Phase 3 SRE model (reference)

This phase defines local/CI-verifiable SRE primitives for the secure-service:

- valid service request population
- availability and latency SLIs
- reference SLOs
- error-budget model
- recording rules
- multi-window burn-rate alerts

These are **reference/portfolio SLOs** and not historical production commitments.

## Telemetry inventory and reuse

Reused existing metrics:

- `app_requests_total{method,endpoint,http_status}`
- `app_request_latency_seconds{method,endpoint}` histogram

No metric names were replaced. Existing instrumentation was completed in middleware so those metrics are emitted per request with bounded `endpoint` labels (`route.path` template or `__unmatched__`).

## Valid service traffic definition

SLI denominator includes:

- HTTP requests where `endpoint` is not `^/(health|ready|metrics)$`

Excluded:

- `/health`
- `/ready`
- `/metrics`

This prevents probe traffic from inflating user-facing reliability.

## Availability SLI

Success model:

- 5xx are treated as service failures.
- non-5xx are treated as successful handling for this reference model.

PromQL:

```promql
1 - (
  sum(rate(app_requests_total{endpoint!~"^/(health|ready|metrics)$",http_status=~"5.."}[5m]))
  /
  sum(rate(app_requests_total{endpoint!~"^/(health|ready|metrics)$"}[5m]))
)
```

## Latency SLI

Objective model:

- fraction of valid requests completed under 500ms

PromQL:

```promql
sum(rate(app_request_latency_seconds_bucket{endpoint!~"^/(health|ready|metrics)$",le="0.5"}[5m]))
/
sum(rate(app_request_latency_seconds_count{endpoint!~"^/(health|ready|metrics)$"}[5m]))
```

## Reference SLOs

- Availability: **99.9%**, rolling 30-day intent
- Latency: **95% of valid requests < 500ms**

## Error budget

Availability SLO = 99.9%

- allowed failure ratio = `1 - 0.999 = 0.001` (0.1%)
- conceptual uptime budget over 30 days ≈ 43m 12s

Burn rate formula used in rules:

```text
burn_rate = error_ratio / 0.001
```

## Burn-rate alerts

- Fast burn (`critical`): 5m and 30m windows both > 14.4
- Slow burn (`warning`): 30m and 2h windows both > 3

Rationale:

- fast detects acute budget exhaustion risk quickly
- slow detects sustained degradation before full budget depletion

