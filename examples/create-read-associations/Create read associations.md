# Create Read Associations

This example demonstrates how to create and read associations between HubSpot CRM objects (deals and companies) using both default and custom association labels, then retrieve the created associations.

## Prerequisites

1. **HubSpot Setup**
   > Refer to the [HubSpot setup guide](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/tree/main/ballerina/Package.md) to obtain your OAuth2 credentials.

2. **Configuration**
   
   Create a `Config.toml` file in the project root directory with your HubSpot OAuth2 credentials:

   ```toml
   clientId = "<Your Client ID>"
   clientSecret = "<Your Client Secret>"
   refreshToken = "<Your Refresh Token>"
   ```

   > **Note:** You will also need to update the object IDs in the code (`FROM_OBJECT_ID_1`, `TO_OBJECT_ID_1`, `FROM_OBJECT_ID_2`, `TO_OBJECT_ID_2`) to match existing deals and companies in your HubSpot account.

## Run the Example

Execute the following command to run the example. The script will create associations between deals and companies, then read and display the created associations.

```shell
bal run
```