# ADR 0004: Multi-window burn-rate alerting

## Status
Accepted

## Context
Single-window threshold alerts were too noisy and slow to indicate true error-budget risk.

## Decision
Use Prometheus recording rules and multi-window burn-rate alerts (fast and slow) for availability and latency SLOs.

## Consequences
- Faster detection of severe regressions and lower noise for transient spikes.
- Promtool tests are required to validate healthy, degradation, and recovery behavior.
