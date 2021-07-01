// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
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

import ballerina/io;
import ballerina/log;
import ballerina/test;

configurable string & readonly refreshUrl = ?;
configurable string & readonly refreshToken = ?;
configurable string & readonly clientId = ?;
configurable string & readonly clientSecret = ?;

Configuration configuration = {
    clientConfig: {
        refreshUrl: refreshUrl,
        refreshToken : refreshToken,
        clientId : clientId,
        clientSecret : clientSecret
        // scopes: ["offline_access","https://graph.microsoft.com/Files.ReadWrite.All"]
    }
};

Client calendarClient = check new(configuration);

string eventId  = "AQMkADAwATMwMAItMDM2My0wNDM5LTAwAi0wMAoARgAAA3Nxbo35rYBItWnfGtTTavgHAN9eh_UmTBdAjsEB8aBad68AAAIBDQAAAN9eh_UmTBdAjsEB8aBad68AAX6kTfgAAAA=";


@test:Config {
    enable: true
}
function testGetEvent() {
    log:printInfo("client->testGetEvent()"); 
    Event|error event = calendarClient->getEvent(eventId);
    if(event is Event) {
        log:printInfo("Event received with ID : " + event.id.toString());
    } else {
        test:assertFail(msg = event.message());
    }
    io:println("\n\n");
}
