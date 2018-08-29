---
title: "Email reference"
---
# Email reference

## Receiving email
The registers service has a public email address: `enquiries@registers.service.gov.uk`

Our service domain is set up as a custom domain for GSuite, which is managed by the IT team.

This is linked to a google group which is owned by our team, and emails are forwarded on from there.

## Sending email
We plan to use mailchimp to send monthly updates to users who have subscribed to updates. These are sent from the above email address.

We’ve added [DKIM and SPF](https://mailchimp.com/help/set-up-custom-domain-authentication-dkim-and-spf/) records to avoid emails don’t get marked as spam.

Users can unsubscribe using the link in their email. This takes them to the mailchimp unsubscribe page.

## Credentials
There is a mailchimp API key and a team account stored in the [pass credentials](https://github.com/openregister/credentials).

## API integration
Registers frontend integrates with the mailchimp API to add users to lists. The list ID can be found on the list name and defaults page. It's different to the ID shown in the URL.

## Removing a user's data
If users request their data to be removed, mailchimp will contact us and we will need to [delete and remove the contact within 30 days](https://mailchimp.com/help/delete-contacts/).

## See also
- [Manage DNS records](/manual/manage-dns-records.html)
- [ADR: Use an external service for email](https://github.com/openregister/registers-frontend/blob/master/doc/adr/0002-external-service-for-email.md)