## Overview

[HubSpot](https://www.hubspot.com/) is a cloud-based customer relationship management (CRM) platform that helps businesses manage their marketing, sales, customer service, and content management needs through an integrated suite of tools.

The `ballerinax/hubspot.crm.associations` package offers APIs to connect and interact with [HubSpot CRM Associations API](https://developers.hubspot.com/docs/api/crm/associations) endpoints, specifically based on [HubSpot CRM Associations API v4](https://developers.hubspot.com/docs/api/crm/associations).
## Setup guide

To use the HubSpot CRM Associations connector, you must have access to the HubSpot API through a [HubSpot developer account](https://developers.hubspot.com/) and obtain an API access token. If you do not have a HubSpot account, you can sign up for one [here](https://app.hubspot.com/signup-hubspot/crm).

### Step 1: Create a HubSpot Account

1. Navigate to the [HubSpot website](https://www.hubspot.com/) and sign up for an account or log in if you already have one.

2. Note that while HubSpot offers a free CRM, certain API features and higher rate limits may require a Professional or Enterprise plan subscription.

### Step 2: Generate an API Access Token

HubSpot uses Private Apps to generate access tokens for API authentication.

1. Log in to your HubSpot account.

2. In the main navigation bar, click the Settings icon (gear icon) in the top right corner.

3. In the left sidebar menu, navigate to Integrations > Private Apps.

4. Click Create a private app.

5. On the Basic Info tab, enter a name and description for your app.

6. Navigate to the Scopes tab and select the required scopes for CRM associations (e.g., `crm.objects.contacts.read`, `crm.objects.contacts.write`, `crm.objects.companies.read`, `crm.objects.companies.write`).

7. Click Create app in the top right corner, then click Continue creating to confirm.

8. After the app is created, your access token will be displayed. Click Show token to reveal it.

> **Tip:** You must copy and store this key somewhere safe. It won't be visible again without clicking "Show token," and for security reasons, you should treat it as a sensitive credential.
## Quickstart

To use the `HubSpot CRM Associations` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

```ballerina
import ballerina/oauth2;
import ballerinax/hubspot.crm.associations as hscrmassoc;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file and configure the obtained credentials:

```toml
clientId = "<Your_Client_Id>"
clientSecret = "<Your_Client_Secret>"
refreshToken = "<Your_Refresh_Token>"
```

2. Create a `hscrmassoc:ConnectionConfig` and initialize the client:

```ballerina
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

final hscrmassoc:Client hscrmassocClient = check new ({
    auth: {
        clientId,
        clientSecret,
        refreshToken
    }
});
```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations.

#### Create associations between objects

```ballerina
public function main() returns error? {
    hscrmassoc:BatchInputPublicAssociationMultiPost payload = {
        inputs: [
            {
                'from: {
                    id: "12345"
                },
                to: {
                    id: "67890"
                },
                types: [
                    {
                        associationCategory: "HUBSPOT_DEFINED",
                        associationTypeId: 1
                    }
                ]
            }
        ]
    };

    hscrmassoc:BatchResponseLabelsBetweenObjectPair response = check hscrmassocClient->/associations/["contacts"]/["companies"]/batch/create.post(payload);
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```
## Examples

The `hubspot.crm.associations` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/tree/main/examples), covering the following use cases:

1. [Create delete associations](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/tree/main/examples/create-delete-associations) - Demonstrates how to create and delete associations between CRM objects using the HubSpot connector.
2. [Create read associations](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/tree/main/examples/create-read-associations) - Illustrates creating associations and retrieving existing associations between records.
3. [Contact company association](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/tree/main/examples/contact-company-association) - Shows how to manage associations between contacts and companies in HubSpot CRM.