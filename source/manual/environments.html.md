---
title: "Environment reference"
---
# Environment reference

## Openregister Java
ORJ has test environments and production environments.

Within each environment registers are deployed in two configurations:

- **basic** hosts the registers register (the catalog of official registers), the fields register, and the data type register
- **multi** hosts all the other registers

### Test
Test is automatically deployed everytime a PR is merged to master.

Example test register: [country.test.openregister.org](https://country.test.openregister.org)

### Production
Live registers are divided into upcoming and ready to use.
Upcoming are hosted on the alpha environment, and ready to use are hosted on the beta environment.

After you merge a PR, you need to manually approve the deploy in AWS Code Pipeline to deploy to both of these environments.

- Example alpha register: [school-eng.alpha.openregister.org](https://country.alpha.openregister.org)
- Example beta register: [country.beta.openregister.org](https://country.beta.openregister.org)

## Registers frontend
Registers frontend has a production environment and a research environment.

PRs are automatically deployed to production when merged. The research environment can also be used for testing.