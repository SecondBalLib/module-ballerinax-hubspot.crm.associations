# Contact Company Association

This example demonstrates how to establish and verify contact-to-company associations in HubSpot CRM using the Ballerina HubSpot CRM Associations connector. The script creates batch associations linking multiple contacts to companies, then verifies the associations by retrieving them for specific contacts.

## Prerequisites

1. **HubSpot Setup**
   > Refer to the [HubSpot setup guide](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/tree/main/ballerina/Package.md#setup-guide) to obtain your access token.

2. **Configuration**
   
   Create a `Config.toml` file in the project root directory with your credentials:

   ```toml
   accessToken = "<Your Access Token>"
   ```

## Run the Example

Execute the following command to run the example. The script will print its progress to the console, showing the batch association creation and verification steps.

```bash
bal run
```

Upon successful execution, you will see output similar to:

```
=== Customer Relationship Mapping Workflow ===
Establishing and verifying contact-to-company associations in HubSpot CRM

✓ HubSpot CRM Associations client initialized successfully

--- Step 1: Creating Batch Associations (Contacts → Companies) ---
Batch association request prepared:
  - Contact 101 → Company 201
  - Contact 102 → Company 201
  - Contact 103 → Company 202

...

=== Workflow Summary ===
✓ Batch associations created: 3
✓ Associations verified for Contact 101: 1
✓ Associations verified for Contact 102: 1

Customer relationship mapping workflow completed successfully!
```