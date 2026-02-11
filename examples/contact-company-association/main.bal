import ballerina/io;
import ballerinax/hubspot.crm.associations;

configurable string accessToken = ?;

public function main() returns error? {
    io:println("=== Customer Relationship Mapping Workflow ===");
    io:println("Establishing and verifying contact-to-company associations in HubSpot CRM\n");

    associations:ConnectionConfig config = {
        auth: {
            token: accessToken
        }
    };
    
    associations:Client hubspotClient = check new (config);
    io:println("✓ HubSpot CRM Associations client initialized successfully\n");

    io:println("--- Step 1: Creating Batch Associations (Contacts → Companies) ---");

    associations:BatchInputPublicDefaultAssociationMultiPost batchPayload = {
        inputs: [
            {
                'from: {id: "101"},
                to: {id: "201"}
            },
            {
                'from: {id: "102"},
                to: {id: "201"}
            },
            {
                'from: {id: "103"},
                to: {id: "202"}
            }
        ]
    };

    io:println("Batch association request prepared:");
    io:println("  - Contact 101 → Company 201");
    io:println("  - Contact 102 → Company 201");
    io:println("  - Contact 103 → Company 202\n");

    associations:BatchResponsePublicDefaultAssociation batchResponse = check hubspotClient->/associations/["contacts"]/["companies"]/batch/associate/'default.post(batchPayload);

    io:println("Batch association response:");
    io:println("  Status: " + batchResponse.status);
    io:println("  Started at: " + batchResponse.startedAt);
    io:println("  Completed at: " + batchResponse.completedAt);
    int resultsLength = batchResponse.results.length();
    io:println("  Results count: " + resultsLength.toString());

    foreach associations:PublicDefaultAssociation result in batchResponse.results {
        string fromId = result.'from.id;
        string toId = result.to.id;
        io:println("  - Association created: Contact " + fromId + " → Company " + toId);
        
        associations:AssociationSpec associationSpec = result.associationSpec;
        int? typeIdValue = associationSpec["typeId"];
        string? categoryValue = associationSpec["category"];
        
        if typeIdValue is int {
            io:println("    Association Type ID: " + typeIdValue.toString());
        }
        if categoryValue is string {
            io:println("    Category: " + categoryValue);
        }
    }

    int? numErrorsValue = batchResponse.numErrors;
    if numErrorsValue is int && numErrorsValue > 0 {
        io:println("\n  ⚠ Errors encountered: " + numErrorsValue.toString());
        associations:StandardError[]? errors = batchResponse.errors;
        if errors is associations:StandardError[] {
            foreach associations:StandardError err in errors {
                io:println("    Error: " + err.message);
                io:println("    Category: " + err.category);
            }
        }
    } else {
        io:println("\n✓ All associations created successfully without errors");
    }

    io:println("\n--- Step 2: Verifying Associations for Contact 101 ---");

    string contactIdToVerify = "101";
    
    associations:CollectionResponseMultiAssociatedObjectWithLabelForwardPaging associationsResponse = 
        check hubspotClient->/objects/["contacts"]/[contactIdToVerify]/associations/["companies"].get(
            'limit = 100
        );

    io:println("Associations retrieved for Contact " + contactIdToVerify + ":");
    int associationsLength = associationsResponse.results.length();
    io:println("  Total associations found: " + associationsLength.toString());

    foreach associations:MultiAssociatedObjectWithLabel association in associationsResponse.results {
        int objectId = association.toObjectId;
        io:println("\n  Associated Company ID: " + objectId.toString());
        io:println("  Association Types:");
        
        foreach associations:AssociationSpecWithLabel assocType in association.associationTypes {
            int typeIdVal = assocType.typeId;
            string categoryVal = assocType.category;
            io:println("    - Type ID: " + typeIdVal.toString());
            io:println("      Category: " + categoryVal);
            
            string? label = assocType?.label;
            if label is string {
                io:println("      Label: " + label);
            } else {
                io:println("      Label: (default association - no custom label)");
            }
        }
    }

    associations:ForwardPaging? paging = associationsResponse.paging;
    if paging is associations:ForwardPaging {
        associations:NextPage? nextPage = paging?.next;
        if nextPage is associations:NextPage {
            io:println("\n  Note: More associations available. Next page cursor: " + nextPage.after);
        }
    }

    io:println("\n--- Step 3: Verifying Associations for Contact 102 ---");

    string secondContactId = "102";
    
    associations:CollectionResponseMultiAssociatedObjectWithLabelForwardPaging secondContactAssociations = 
        check hubspotClient->/objects/["contacts"]/[secondContactId]/associations/["companies"].get();

    io:println("Associations retrieved for Contact " + secondContactId + ":");
    int secondAssociationsLength = secondContactAssociations.results.length();
    io:println("  Total associations found: " + secondAssociationsLength.toString());

    foreach associations:MultiAssociatedObjectWithLabel association in secondContactAssociations.results {
        int objectIdVal = association.toObjectId;
        io:println("  - Associated Company ID: " + objectIdVal.toString());
        
        foreach associations:AssociationSpecWithLabel assocType in association.associationTypes {
            int typeIdDisplay = assocType.typeId;
            string categoryDisplay = assocType.category;
            string? labelVal = assocType?.label;
            string labelDisplay = labelVal ?: "default";
            io:println("    Type: " + typeIdDisplay.toString() + " | Category: " + categoryDisplay + " | Label: " + labelDisplay);
        }
    }

    io:println("\n=== Workflow Summary ===");
    int batchResultsLength = batchResponse.results.length();
    int verifiedAssociationsLength = associationsResponse.results.length();
    int secondVerifiedLength = secondContactAssociations.results.length();
    io:println("✓ Batch associations created: " + batchResultsLength.toString());
    io:println("✓ Associations verified for Contact 101: " + verifiedAssociationsLength.toString());
    io:println("✓ Associations verified for Contact 102: " + secondVerifiedLength.toString());
    io:println("\nCustomer relationship mapping workflow completed successfully!");
}