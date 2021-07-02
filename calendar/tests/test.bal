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
string defaultCalendarId = "AQMkADAwATMwMAItMDM2My0wNDM5LTAwAi0wMAoARgAAA3Nxbo35rYBItWnfGtTTavgHAN9eh_UmTBdAjsEB8aBad68AAAIBBgAAAN9eh_UmTBdAjsEB8aBad68AAQ_WzOwAAAA=";
string[] queryParamSelect = ["$select=subject"];
string[] queryParamTop = ["$top=1"];

@test:Config {
    enable: true
}
function testGetEvent() {
    log:printInfo("client->testGetEvent()"); 
    Event|error event = calendarClient->getEvent(eventId, queryParamSelect);
    if(event is Event) {
        log:printInfo("Event received with ID : " + event.id.toString());
    } else {
        test:assertFail(msg = event.message());
    }
    io:println("\n\n");
}

@test:Config {
    enable: true
}
function testListEvents() {
    log:printInfo("client->testListEvents()"); 
    stream<Event, error>|error eventStream = calendarClient->listEvents(queryParamTop);
    if (eventStream is stream<Event, error>) {
        error? e = eventStream.forEach(isolated function (Event event) {
            log:printInfo(event.id.toString());
        });
    } else {
        test:assertFail(msg = eventStream.message());
    }
    io:println("\n\n");
}

@test:Config {
    enable: true
}
function testAddQuickEvent() {
    log:printInfo("client->testAddQuickEvent()");
    string subject = "Test-Subject";
    string body = "Test-Subject";
    Event|error event = calendarClient->addQuickEvent(subject, body, defaultCalendarId);
    if (event is Event) {
        log:printInfo("Event created with subject : " +event?.subject.toString());
    } else {
        test:assertFail(msg = event.message());
    }
    io:println("\n\n");
}


@test:Config {
    enable: true
}
function testCreateEvent() {
    log:printInfo("client->testCreateEvent()");
    EventMetadata eventMetadata = {
        subject: "Test-Subject-1",
        'start: {
            dateTime: "2017-04-15T12:00:00",
            timeZone: "Pacific Standard Time"
        },
        end: {
            dateTime: "2017-04-15T14:00:00",
            timeZone: "Pacific Standard Time"
        },
        location:{
            displayName:"Harry's Bar"
        },
        attendees: [{
            emailAddress: {
                address:"samanthab@contoso.onmicrosoft.com",
                name: "Samantha Booth"
            },
            'type: "required"
        }],
        allowNewTimeProposals: true,
        transactionId:"7E163156-7762-4BEB-A1C6-729EA81755A7"

    };
    Event|error event = calendarClient->createEvent(eventMetadata);
    if (event is Event) {
        log:printInfo("Event created with subject : " +event?.subject.toString());
    } else {
        test:assertFail(msg = event.message());
    }
    io:println("\n\n");
}