---
title: "Manage DNS records"
---
# Manage DNS records

We use AWS Route 53 to manage all our DNS.

We use [terraform](https://github.com/openregister/deployment) to manage the `register.gov.uk` and `openregister.org` domains.

Records for `registers.service.gov.uk` are managed manually in Route 53.

## See also
- [DNS in the GOV.UK developer docs](https://docs.publishing.service.gov.uk/manual/dns.html) explains how the .gov.uk top level domain and service.gov.uk are managed.