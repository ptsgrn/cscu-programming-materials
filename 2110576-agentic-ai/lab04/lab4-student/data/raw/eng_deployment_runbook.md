# Deployment Runbook

Document ENG-021, revision 19. Owner: Platform team. On-call rota: PagerDuty schedule `platform-primary`.

## Environments

| Environment | Cluster | Purpose |
|---|---|---|
| dev | `sr-dev-1` | continuous deploy from `main` |
| staging | `sr-stg-1` | release candidates, mirrors production data shape |
| production | `sr-prod-1`, `sr-prod-2` | customer traffic, two regions active-active |

## Release process

Releases are cut every Tuesday at 10:00 ICT. A release freeze applies from 16:00 Friday until 10:00 Monday, and for the full week of any public holiday cluster.

1. Tag the release candidate as `vYYYY.MM.N-rc1`.
2. CI runs the full suite. A release cannot proceed with any failing or skipped integration test.
3. Deploy to staging. Soak for at least 60 minutes with synthetic traffic from `sr-load-gen`.
4. Check the four release gates: error rate below 0.5%, p95 latency below 400 ms, no new `ERROR` log signatures, queue depth stable.
5. Promote to `sr-prod-1` only. Wait 30 minutes. Then promote to `sr-prod-2`.

Never promote both production regions in the same step. The 30-minute gap exists so that a regression that only appears under real traffic is contained to one region.

## Rollback

Rollback is a single command:

```
srctl rollback --service <name> --to <previous-tag> --region <region>
```

Rollback takes about 90 seconds. The decision rule is deliberately blunt: if the error rate exceeds 2% for 5 consecutive minutes after a deploy, roll back first and investigate afterwards. Do not attempt a forward fix during an active incident unless the rollback itself is broken.

Database migrations are not covered by `srctl rollback`. Migrations must be backward compatible for at least one release, following the expand-migrate-contract pattern described in ENG-030.

## Feature flags

New behaviour ships behind a flag in LaunchDarkly, defaulted off. Flags older than 90 days are flagged by the weekly hygiene job and must be either removed or documented as permanent configuration.
