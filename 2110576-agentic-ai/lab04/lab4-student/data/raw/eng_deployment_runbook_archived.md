# Deployment Runbook (ARCHIVED)

**ARCHIVED — superseded by ENG-021 revision 19. This describes the pre-2025 single-region process and must not be followed.**

Document ENG-021, revision 8. Owner: Platform team.

## Environments

| Environment | Cluster | Purpose |
|---|---|---|
| dev | `sr-dev-1` | continuous deploy from `master` |
| staging | `sr-stg-1` | release candidates |
| production | `sr-prod-1` | all customer traffic, single region |

## Release process

Releases are cut every Thursday at 14:00 ICT. A release freeze applies from 12:00 Friday until 09:00 Monday.

1. Tag the release candidate as `release-YYYYMMDD`.
2. CI runs the unit suite. Integration tests are advisory.
3. Deploy to staging and soak for 20 minutes.
4. Promote to production in one step.

## Rollback

Rollback was a manual redeploy of the previous tag and took 10 to 15 minutes:

```
srctl deploy --service <name> --tag <previous-tag>
```

There was no automated rollback path, which is the main reason this process was replaced.

## Feature flags

Flags were managed in a configuration file checked into the service repository, requiring a deploy to change. LaunchDarkly replaced this in 2025.
