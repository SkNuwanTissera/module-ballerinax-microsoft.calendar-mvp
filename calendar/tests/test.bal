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

string eventId  = "";
string defaultCalendarId = "";
string[] queryParamSelect = ["$select=subject"];
string[] queryParamTop = ["$top=1"];

@test:Config {
    enable: true,
    groups: ["events"],
    before: testCreateEvent,
    after: testDeleteEvent
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

@test:Config {
    enable: true,
    groups: ["events"],
    before: testCreateEvent,
    after: testDeleteEvent
}
function testGetEventWithPreferenceHeaders() {
    log:printInfo("client->testGetEventWithPreferenceHeaders()"); 
    Event|error event = calendarClient->getEvent(eventId, timeZone=TIMEZONE_AD, contentType=CONTENT_TYPE_TEXT);
    if(event is Event) {
        log:printInfo("Event received with requested timezone : " + event?.'start?.timeZone.toString());
    } else {
        test:assertFail(msg = event.message());
    }
    io:println("\n\n");
}

@test:Config {
    enable: true,
    groups: ["events"],
    before: testCreateEvent,
    after: testDeleteEvent
}
function testGetEventWithQueryParameters() {
    log:printInfo("client->testGetEventWithPreferenceHeaders()"); 
    Event|error event = calendarClient->getEvent(eventId, queryParams=queryParamSelect);
    if(event is Event) {
        log:printInfo("Event received with ID: " + event.id.toString());
    } else {
        test:assertFail(msg = event.message());
    }
    io:println("\n\n");
}

@test:Config {
    enable: true,
    groups: ["events"],
    before: testCreateEvent,
    after: testDeleteEvent
}
function testListEvents() {
    log:printInfo("client->testListEvents()"); 
    stream<Event, error>|error eventStream 
        = calendarClient->listEvents(timeZone=TIMEZONE_AD, contentType=CONTENT_TYPE_TEXT, queryParams = queryParamTop);
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
    groups: ["events"],
    enable: true
}
function testAddQuickEvent() {
    log:printInfo("client->testAddQuickEvent()");
    string subject = "Test-Subject";
    string body = "Test-Subject";
    Event|error event = calendarClient->addQuickEvent(subject, body);
    if (event is Event) {
        log:printInfo("Event created with ID : " +event.id.toString());
    } else {
        test:assertFail(msg = event.message());
    }
    io:println("\n\n");
}


@test:Config {
    enable: true,
    groups: ["events"],
    dependsOn: [testCreateEventWithMultipleLocations]
}
function testCreateEvent() {
    log:printInfo("client->testCreateEvent()");
    EventMetadata eventMetadata = {
        subject: "Test-Subject-1",
        body : {
            content: "Test-Body-1"
        },
        'start: {
            dateTime: "2021-07-16T12:00:00",
            timeZone: TIMEZONE_LK
        },
        end: {
            dateTime: "2021-07-16T14:00:00",
            timeZone: TIMEZONE_LK
        },
        location:{
            displayName:"Harry's Bar"
        },
        attendees: [{
            emailAddress: {
                address:"samanthab@contoso.onmicrosoft.com",
                name: "Samantha Booth"
            },
            'type: ATTENDEE_TYPE_REQUIRED,
            status: {
                response : RESPONSE_NOT_RESPONDED
            }
        }],
        allowNewTimeProposals: true
    };
    Event|error generatedEvent = calendarClient->createEvent(eventMetadata);
    if (generatedEvent is Event) {
        eventId = generatedEvent.id.toString();
        log:printInfo("Event created with ID : " +eventId.toString());
    } else {
        test:assertFail(msg = generatedEvent.message());
    }
    io:println("\n\n");
}

@test:Config {
    groups: ["events"],
    enable: true
}
function testCreateEventWithMultipleLocations() {
    log:printInfo("client->testCreateEventWithMultipleLocations()");
    EventMetadata eventMetadata = {
    subject: "Plan summer company picnic",
    body: {
        contentType: "text",
        content: "Let's kick-start this event planning!"
    },
    'start: {
        dateTime: "2021-08-30T11:00:00",
        timeZone: "Pacific Standard Time"
    },
    end: {
        dateTime: "2021-08-30T12:00:00",
        timeZone: "Pacific Standard Time"
    },
    attendees: [
        {
        emailAddress: {
            address: "DanaS@contoso.onmicrosoft.com",
            name: "Dana"
        },
        'type: ATTENDEE_TYPE_REQUIRED
        },
        {
        emailAddress: {
            address: "AlexW@contoso.onmicrosoft.com",
            name: "Alex Wilber"
        },
        'type: ATTENDEE_TYPE_OPTIONAL
        }
    ],
    location: {
        displayName: "Conf Room 3; Fourth Coffee; Home Office",
        locationType: LOCATION_TYPE_DEFAULT
    },
    locations: [
        {
        displayName: "Conf Room 3"
        },
        {
        displayName: "Fourth Coffee",
        address: {
            street: "4567 Main St",
            city: "Redmond",
            state: "WA",
            countryOrRegion: "US",
            postalCode: "32008"
        },
        coordinates: {
            latitude: 47.672,
            longitude: -102.103
        }
        },
        {
        displayName: "Home Office"
        }
    ],
    allowNewTimeProposals: true
    };
    Event|error generatedEvent = calendarClient->createEvent(eventMetadata);
    if (generatedEvent is Event) {
        eventId = generatedEvent.id.toString();
        log:printInfo("Event created with ID : " +eventId.toString());
    } else {
        test:assertFail(msg = generatedEvent.message());
    }
    io:println("\n\n");
}

@test:Config {
    enable: true,
    groups: ["events"],
    before: testCreateEvent,
    after: testDeleteEvent
}
function testUpdateEvent() {
    log:printInfo("client->testUpdateEvent()"); 
    EventMetadata eventBody  = {
        subject : "Changed the Subject during Update Event",
        isAllDay : false, // if this is true, you need to provide `Start` and `End` also.
        'start : {
            dateTime : "2015-09-08T00:00:00.000Z",
            timeZone : TIMEZONE_AD
        },
        end : {
            dateTime : "2015-09-09T00:00:00.000Z",
            timeZone : TIMEZONE_AD
        },
        responseStatus: {
            response: RESPONSE_ACCEPTED
        },
        recurrence : null,
        importance : IMPORTANCE_HIGH,
        reminderMinutesBeforeStart : 99,
        isOnlineMeeting : true,
        sensitivity : SENSITIVITY_PERSONAL,
        showAs : SHOW_AS_BUSY,
        onlineMeetingProvider : ONLINE_MEETING_PROVIDER_TYPE_TEAMS_FOR_BUSINESS,
        isReminderOn : true,
        hideAttendees : false,
        responseRequested : true,
        categories : ["Red category"]
    };
    Event|error response = calendarClient->updateEvent(eventId, eventBody);
    if (response is Event) {
        log:printInfo("Event updated, Event ID : " +response.id.toString());
    } else {
        test:assertFail(msg = response.message());
    }
    io:println("\n\n");
}

@test:Config {
    enable: true,
    dependsOn: [testCreateEvent, testCreateEventWithMultipleLocations]
}
function testDeleteEvent() {
    log:printInfo("client->testDeleteEvent()"); 
    error? response = calendarClient->deleteEvent(eventId);
    if (response is error) {
        test:assertFail(msg = response.message());
    }
    io:println("\n\n");

}
