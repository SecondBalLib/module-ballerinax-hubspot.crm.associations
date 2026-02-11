# Create Delete Associations

This example demonstrates how to manage associations between HubSpot CRM objects (deals and companies) using the HubSpot CRM Associations connector. The script creates default associations, creates labeled associations, reads existing associations, and deletes both specific and all associations between objects.

## Prerequisites

1. **HubSpot Setup**
   > Refer to the [HubSpot setup guide](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/blob/main/ballerina/Package.md#setup-guide) to obtain OAuth2 credentials.

2. **Configuration**
   Create a `Config.toml` file in the project root directory with your HubSpot OAuth2 credentials:

   ```toml
   clientId = "<Your Client ID>"
   clientSecret = "<Your Client Secret>"
   refreshToken = "<Your Refresh Token>"
   ```

3. **Object IDs**
   Update the `FROM_OBJECT_ID` and `TO_OBJECT_ID` constants in `main.bal` with valid deal and company IDs from your HubSpot account.

## Run the Example

Execute the following command to run the example. The script will print its progress to the console, showing the results of each association operation.

```shell
bal run
```