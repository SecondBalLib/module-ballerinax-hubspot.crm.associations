// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/os;
import ballerina/test;
import hubspot.crm.associations.mock.server as _;

configurable boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
configurable string token = isLiveServer ? os:getEnv("HUBSPOT_TOKEN") : "test_token";
configurable string serviceUrl = isLiveServer ? "https://api.hubapi.com/crm/v4" : "http://localhost:9090/crm/v4";

ConnectionConfig config = {auth: {token: token}};
final Client hubspotClient = check new Client(config, serviceUrl);

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testDeleteAssociation() returns error? {
    error? response = check hubspotClient->/objects/["contacts"]/["12345"]/associations/["companies"]/["67890"].delete();
    test:assertTrue(response is (), "Expected no error on successful delete");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testListAssociations() returns error? {
    CollectionResponseMultiAssociatedObjectWithLabelForwardPaging response = check hubspotClient->/objects/["contacts"]/["12345"]/associations/["companies"]();
    test:assertTrue(response.results.length() > 0, "Expected a non-empty results array");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testBatchArchiveAssociations() returns error? {
    BatchInputPublicAssociationMultiArchive payload = {
        inputs: [
            {
                'from: {id: "12345"},
                to: [{id: "67890"}]
            }
        ]
    };
    BatchResponseVoid|error response = hubspotClient->/associations/["contacts"]/["companies"]/batch/archive.post(payload);
    if response is BatchResponseVoid {
        test:assertTrue(true, "Expected successful response");
    } else {
        test:assertFail("Expected successful response but got error");
    }
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testBatchAssociateDefault() returns error? {
    BatchInputPublicDefaultAssociationMultiPost payload = {
        inputs: [
            {
                'from: {id: "12345"},
                to: {id: "67890"}
            }
        ]
    };
    BatchResponsePublicDefaultAssociation response = check hubspotClient->/associations/["contacts"]/["companies"]/batch/associate/default.post(payload);
    test:assertTrue(response.results.length() >= 0, "Expected results array to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testBatchCreateAssociations() returns error? {
    PublicAssociationMultiPost associationInput = {
        'from: {id: "12345"},
        to: {id: "67890"},
        types: [
            {
                associationCategory: "HUBSPOT_DEFINED",
                associationTypeId: 1
            }
        ]
    };
    BatchInputPublicAssociationMultiPost payload = {
        inputs: [associationInput]
    };
    BatchResponseLabelsBetweenObjectPair response = check hubspotClient->/associations/["contacts"]/["companies"]/batch/create.post(payload);
    test:assertTrue(response.results.length() >= 0, "Expected results array to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testBatchArchiveLabels() returns error? {
    PublicAssociationMultiPost labelInput = {
        'from: {id: "12345"},
        to: {id: "67890"},
        types: [
            {
                associationCategory: "HUBSPOT_DEFINED",
                associationTypeId: 1
            }
        ]
    };
    BatchInputPublicAssociationMultiPost payload = {
        inputs: [labelInput]
    };
    BatchResponseVoid|error response = hubspotClient->/associations/["contacts"]/["companies"]/batch/labels/archive.post(payload);
    if response is BatchResponseVoid {
        test:assertTrue(true, "Expected successful response");
    } else {
        test:assertFail("Expected successful response but got error");
    }
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testBatchReadAssociations() returns error? {
    BatchInputPublicFetchAssociationsBatchRequest payload = {
        inputs: [
            {id: "12345"},
            {id: "54321"}
        ]
    };
    BatchResponsePublicAssociationMultiWithLabel response = check hubspotClient->/associations/["contacts"]/["companies"]/batch/read.post(payload);
    test:assertTrue(response.results.length() >= 0, "Expected results array to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testHighUsageReport() returns error? {
    ReportCreationResponse response = check hubspotClient->/associations/usage/high\-usage\-report/[12345].post();
    string? reportIdValue = response["reportId"];
    test:assertTrue(reportIdValue !is (), "Expected reportId to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testCreateDefaultAssociation() returns error? {
    BatchResponsePublicDefaultAssociation response = check hubspotClient->/objects/["contacts"]/["12345"]/associations/default/["companies"]/["67890"].put();
    test:assertTrue(response.results.length() > 0, "Expected a non-empty results array");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testCreateAssociation() returns error? {
    AssociationSpec[] payload = [
        {
            associationCategory: "HUBSPOT_DEFINED",
            associationTypeId: 1
        }
    ];
    LabelsBetweenObjectPair response = check hubspotClient->/objects/["contacts"]/["12345"]/associations/["companies"]/["67890"].put(payload);
    test:assertTrue(response.labels.length() >= 0, "Expected labels array to be present");
}