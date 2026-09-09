# Fleet API Gateway

Document ENG-045, revision 6. Owner: Platform team. Base URL: `https://api.siamrobotics.example/v2`.

## Authentication

All requests require a bearer token issued by the Okta authorisation server. Tokens are valid for 60 minutes and are refreshed with the refresh token grant. Machine-to-machine integrations use the client credentials grant with a client secret rotated every 180 days.

API keys are not supported and will not be added. Long-lived static credentials are the most common cause of the credential leaks described in SEC-002.

## Rate limits

| Tier | Requests per minute | Burst |
|---|---|---|
| standard | 600 | 900 |
| partner | 3,000 | 4,500 |
| internal | unlimited | — |

Exceeding the limit returns HTTP 429 with a `Retry-After` header in seconds. Clients must honour `Retry-After` and apply jitter; synchronised retries from a fleet of clients turn a brief limit into a sustained outage.

## Core endpoints

- `GET /robots` — list robots with status, battery level and current task.
- `GET /robots/{id}/telemetry` — last 24 hours of telemetry, 1 Hz resolution. Older data is served from the warehouse via `POST /queries` instead.
- `POST /tasks` — enqueue a task. Idempotent when an `Idempotency-Key` header is supplied; keys are retained for 24 hours.
- `POST /robots/{id}/recall` — send a robot to its dock. Takes effect within 2 seconds.

## Versioning

Breaking changes require a new major version path. v1 was retired on 30 June 2026. Two major versions are supported at once, and the deprecated version receives security fixes only, with a minimum 12-month deprecation window announced through the developer changelog.

## Errors

Errors return a JSON body with `code`, `message` and `request_id`. Always log `request_id` — support cannot trace an issue without it.
