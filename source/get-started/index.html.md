---
title: "Get started"
weight: 60
---

# Get started
This guide documents things you need to do when you join the team.

## 1. Set up your development environment

Follow the instructions for the thing you want to work on:

- [Registers frontend](https://github.com/openregister/registers-frontend)
- [Openregister Java](https://github.com/openregister/openregister-java)
- [Deployment](https://github.com/openregister/deployment)

## 2. Access AWS and PaaS environments
Ask somebody to create you accounts for:

- AWS
- PaaS
- GOV.UK Notify

## 3. Deploy a change
Our CI is hosted on travis: [travis-ci.org/openregister](https://travis-ci.org/openregister).

Registers frontend will automatically deploy to production on merge to
master. Be aware that we don't pin the `ruby_buildpack` version used
to build the project so the [latest version from
PaaS](https://github.com/alphagov/paas-cf/commits/master/config/buildpacks.yml)
will be used up by Travis and that can sometimes be a cause of issues
as dependencies evolve. See an example on this [GitHub
issue](https://github.com/openregister/registers-frontend/issues/667).

Openregister Java will automatically deploy to test on merge. You need to approve the release in AWS code pipeline to release to production.

Our apps are hosted on the Government PaaS. For more information about our environments see [environments](/manual/environments.html).

See [the PaaS documentation](https://docs.cloud.service.gov.uk) for more information about the Government PaaS and how to manually deploy using Cloud Foundry.
