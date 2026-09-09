# Postmortem: Fleet Coordinator Quorum Loss, 14 March 2026

Severity SEV1. Duration 71 minutes. Author: Reliability team. Status: action items open.

## Impact

Between 09:12 and 10:23 ICT, the fleet coordinator lost quorum across both production regions. 412 robots at 9 customer sites held position and stopped accepting new tasks. No robot moved unexpectedly and there were no safety incidents. Two customers missed a dispatch cut-off.

## Timeline (ICT)

- 09:12 — A network maintenance window at the `sr-prod-2` provider begins 48 minutes earlier than the notified time.
- 09:12 — Partition between `sr-prod-1` and `sr-prod-2`. Coordinator logs fill with `ERR-5521`.
- 09:14 — Alert fires. On-call acknowledges at 09:16.
- 09:21 — An engineer restarts the coordinator in `sr-prod-1`, believing the process is wedged. This is contrary to ENG-007, which states not to restart during a suspected partition.
- 09:23 — The restart clears the in-memory task assignments. Recovery now requires a rebuild from the task log, adding roughly 25 minutes.
- 09:31 — Incident declared SEV1. IC assigned. Roles stated in channel.
- 09:48 — Provider confirms the maintenance window and restores the link.
- 10:02 — Quorum restored. Task log replay begins.
- 10:23 — All 412 robots accepting tasks. Incident resolved.

## Contributing factors

1. The provider started maintenance early and our change calendar had no automated cross-check against provider notifications.
2. The `ERR-5521` runbook entry existed but was three clicks deep in Confluence; the on-call engineer did not find it inside the first ten minutes.
3. The alert said "coordinator unhealthy", which reads like a process fault and invited a restart. The alert did not distinguish a partition from a crash.
4. Nineteen minutes passed before the incident was formally declared, so there was no IC while the most consequential decision was made.

## What went well

Robots held position safely, exactly as designed. Customer communication went out at 09:35 and every 30 minutes after.

## Action items

| # | Action | Owner | Due |
|---|---|---|---|
| 1 | Alert text distinguishes partition from process failure, and links the runbook directly | Reliability | 2026-04-04 |
| 2 | Declaration is automatic for any SEV1-eligible alert unacknowledged for 5 minutes | Reliability | 2026-04-11 |
| 3 | Ingest provider maintenance notifications into the change calendar | Platform | 2026-04-25 |
| 4 | Coordinator refuses a restart during a suspected partition unless forced with an explicit flag | Platform | 2026-05-09 |
