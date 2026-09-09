# Access Control

Document SEC-002, revision 10. Owner: Security. Reviewed every six months.

## Identity

Okta is the single source of identity. Every system either federates to Okta through SAML or OIDC, or it is on the exception register with a named owner and an expiry date. The exception register currently holds four systems, down from nineteen in 2024.

Hardware security keys are mandatory for all employees. TOTP is allowed only for contractors and only for their first 30 days. SMS is never an accepted second factor.

## Least privilege

Production access is granted just in time. An engineer requests access through `srctl access request --env prod --reason <ticket>`, which grants a 4-hour role. There is no permanent production role for individuals; permanent access exists only for service accounts.

Access reviews run quarterly. A permission that has gone unused for 90 days is revoked automatically. Reinstating it takes minutes, so the default is to revoke.

## Secrets

Secrets live in HashiCorp Vault. Secrets must never appear in source control, CI logs, Jira tickets or Slack. A secret pasted into Slack is considered compromised and must be rotated within 24 hours, even in a private channel, because Slack retention and export put it outside our control.

Client secrets for machine-to-machine integrations rotate every 180 days. Signing keys for robot firmware rotate every 12 months under the schedule in SEC-014.

## Restricted countries

Work from, and access from, countries on the restricted list is blocked at the identity provider. The list is maintained by Legal and is driven by export control obligations on the robot control software, not by general risk appetite. The list is published on the Security Confluence page and updated within 5 working days of any change.

## Offboarding

Okta access is revoked within 60 minutes of the departure being recorded in Workday. Building access is revoked at the same time. Laptop wipe is triggered remotely if the device is not returned within 5 working days, per HR-001.

## Reporting

Suspected incidents go to security@siamrobotics.example or `#security-incidents`. Report first, investigate second. There is no penalty for a report that turns out to be nothing, and there is one for a delayed report that turns out to be something.
