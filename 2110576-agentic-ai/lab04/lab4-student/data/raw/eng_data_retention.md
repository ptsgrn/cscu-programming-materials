# Data Retention

Document ENG-052, revision 4. Owner: Data Platform. Reviewed jointly with Legal each March.

## Retention schedule

| Data class | Hot storage | Archive | Total retention |
|---|---|---|---|
| Robot telemetry (1 Hz) | 30 days | 13 months | 13 months |
| Robot telemetry (1 min rollup) | 13 months | 5 years | 5 years |
| Task and order records | 13 months | 7 years | 7 years |
| Application logs | 14 days | 90 days | 90 days |
| Audit logs | 13 months | 7 years | 7 years |
| Video from onboard cameras | 7 days | none | 7 days |
| Support tickets | indefinite | — | indefinite |

Onboard camera footage is the shortest retention on purpose: it is the only class that can incidentally capture identifiable people in a customer warehouse.

## Deletion

Deletion runs nightly at 02:00 ICT. Deletion is soft for 7 days, then hard. Restoring soft-deleted data requires a ticket approved by the data owner.

Customer deletion requests under PDPA are handled within 30 days by the Data Protection Officer, dpo@siamrobotics.example. Audit logs are exempt from deletion requests because they are held under a separate legal basis.

## Backups

Production databases are backed up hourly with a 35-day retention. A restore drill is performed quarterly against a scratch cluster; a backup that has never been restored is a hypothesis, not a backup. The last drill restored 1.2 TB in 47 minutes.

## Exports

Bulk export to customer S3 buckets is available on the partner tier. Exports are encrypted with the customer's KMS key. Exports containing telemetry older than 13 months are served from the archive tier and can take up to 6 hours to become available.
