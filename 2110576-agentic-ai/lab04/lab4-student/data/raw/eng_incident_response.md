# Incident Response

Document ENG-007, revision 14. Owner: Reliability team.

## Severity levels

- **SEV1** — customer-facing outage or safety risk from a fleet robot. Page immediately. Target acknowledgement 5 minutes, target mitigation 60 minutes.
- **SEV2** — major degradation, workaround exists. Acknowledge within 15 minutes.
- **SEV3** — minor or internal-only impact. Handle in business hours.

Any incident involving unexpected robot motion is automatically SEV1 regardless of customer impact.

## Roles

Every incident has exactly three named roles, assigned in the first five minutes:

- **Incident Commander (IC)** — decides, does not debug. The IC is explicitly forbidden from typing commands; the moment the IC starts debugging, nobody is coordinating.
- **Operations Lead** — makes the changes the IC decides on.
- **Communications Lead** — updates the status page and the customer channel every 30 minutes, even when there is nothing new to say.

## Process

1. Declare in `#incident` with `/incident declare <severity> <one-line summary>`. This opens a dedicated channel and a Zoom bridge.
2. Assign the three roles. State them in the channel.
3. Mitigate first. Root cause analysis happens after customers are served.
4. Resolve, then schedule the postmortem within 5 working days.

## Postmortems

Postmortems are blameless and mandatory for every SEV1 and SEV2. The document must include a timeline in ICT, the contributing factors, what made detection slow, and action items with named owners and due dates. Action items without an owner are not action items.

Postmortems are published company-wide in Confluence space `PM`. There is no private postmortem.

## Common error signatures

- `ERR-5521` — the fleet coordinator lost quorum. Usually a network partition between `sr-prod-1` and `sr-prod-2`. Robots hold position and are safe; do not restart the coordinator before confirming quorum, as a restart during a partition can cause a split-brain assignment.
- `ERR-3310` — battery telemetry stale for more than 90 seconds. Treat as SEV2; affected robots return to dock automatically.
- `ERR-8002` — firmware signature verification failed during OTA update. The robot refuses the update and keeps the previous image. Check the signing key rotation schedule in SEC-014.
