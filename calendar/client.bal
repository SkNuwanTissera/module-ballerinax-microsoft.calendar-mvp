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

import ballerina/http;
import ballerina/log;

# Calender Client Object.
# 
# + httpClient - the HTTP Client
@display {
    label: "Microsoft Calendar Client", 
    iconPath: "MSCalendarLogo.svg"
}
public client class Client {
    http:Client httpClient;

    public isolated function init(Configuration config) returns error? {
        http:BearerTokenConfig|http:OAuth2RefreshTokenGrantConfig clientConfig = config.clientConfig;
        http:ClientSecureSocket? socketConfig = config?.secureSocketConfig;
        self.httpClient = check new (BASE_URL, {
            auth: clientConfig,
            secureSocket: socketConfig,
            cache: {
                enabled: false // Disabled caching for now due to NLP exception in getting the stream for downloads.
            },
            followRedirects: {enabled: true, maxCount: 5}
        });
    }

    # #############################################################################
    # Operations on a Event resource
    # The Event resource is the top-level object representing a event in outlook.
    # #############################################################################
    # Get event by proving the ID
    # Get the properties and relationships of the specified event object.
    # API doc : https://docs.microsoft.com/en-us/graph/api/event-get
    #
    # + eventId - ID of an event. Read-only.  
    # + timeZone - Preferred Time Zone of the start and end time. (Default : `UTC`)
    # + contentType - Preferred Content-Type of the body. Values : `text` or `text` (Default : `html`)
    # + queryParams - Optional query parameters. This method support OData query parameters to customize the response. 
    # It should be an array of type `string` in the format `<QUERY_PARAMETER_NAME>=<PARAMETER_VALUE>`
    # **Note:** For more information about query parameters, refer here: 
    # https://docs.microsoft.com/en-us/graph/query-parameters
    # + return - a record `Event` if success. Else `error`.
    @display {label: "Get Event"}
    remote isolated function getEvent(@display {label: "Event ID"} string eventId, 
                                      @display {label: "Preferred Time Zone"} TimeZone? timeZone = (),
                                      @display {label: "Preferred Content Type"} ContentType? contentType = (),
                                      @display {label: "Optional Query Parameters"} string[] queryParams = []) 
                                      returns @tainted Event|error {
        string path = check createUrl([LOGGED_IN_USER, EVENTS, eventId], queryParams);
        return check getEventById(self.httpClient, path, timeZone, contentType);
    }

    # Get list of events
    # Get the properties and relationships of all event objects as a array.
    # API doc : https://docs.microsoft.com/en-us/graph/api/user-list-events
    #
    # + timeZone - Preferred Time Zone of the start and end time. (Default : `UTC`)
    # + contentType - Preferred Content-Type of the body. Values : `text` or `text` (Default : `html`)
    # + queryParams - Optional query parameters. This method support OData query parameters to customize the response.
    #                 It should be an array of type `string` in the format `<QUERY_PARAMETER_NAME>=<PARAMETER_VALUE>`
    #                 **Note:** For more information about query parameters, refer here: 
    #                   https://docs.microsoft.com/en-us/graph/query-parameters
    # + return - a stream of `Event` if success. Else `error`.
    @display {label: "List Events"}
    remote isolated function listEvents(@display {label: "Preferred Time Zone"} TimeZone? timeZone = (),
                                        @display {label: "Preferred Content Type"} ContentType? contentType = (),
                                        @display {label: "Optional Query Parameters"} string[] queryParams = [])  
                                        returns @tainted stream<Event, error>|error {
        string path = check createUrl([LOGGED_IN_USER, EVENTS], queryParams);
        EventStream objectInstance = check new (self.httpClient, <@untainted>path, timeZone, contentType);
        stream<Event, error> finalStream = new (objectInstance);
        return finalStream;
    }

    # Quick add event
    # This create a event with minimum necessary inputs.
    # API doc : https://docs.microsoft.com/en-us/graph/api/user-post-events
    #
    # + subject - Subject of the event  
    # + description - Description of the event  
    # + calendarId - Calendar ID of the calendar that you want to create the event. If not, Default will be used.
    # + return - `EventId` if success. Else `error`.
    @display {label: "Add Quick Event"}
    remote isolated function addQuickEvent(@display {label: "Title"} string subject, 
                                           @display {label: "Description"} string? description = (),
                                           @display {label: "Calendar ID"} string? calendarId = ()) 
                                           returns @tainted Event|error { 
                                            //TODO : Handle optional calenderId
        EventMetadata newEvent = {
            subject:subject,
            body : { content: description.toString() }
        };
        string path = EMPTY_STRING;
        if (calendarId is string){
            path = check createUrl([LOGGED_IN_USER, CALENDARS, calendarId, EVENTS]);
        } else {
            path = check createUrl([LOGGED_IN_USER, EVENTS]);
        }
        return check self.httpClient->post(<@untainted>path, check newEvent.cloneWithType(json), targetType=Event);
    }

    # Create an event
    # This create a new event with Event object as parameters.
    # API doc : https://docs.microsoft.com/en-us/graph/api/user-post-events
    #
    # + eventMetadata - Metadata related to Event that we are passing on input.  
    # + calendarId - Calendar ID of the calendar that you want to create the event. 
    # + return - `EventId` if success. Else `error`.
    @display {label: "Create Event"}
    remote isolated function createEvent(@display {label: "Event Metadata"} EventMetadata eventMetadata,
                                         @display {label: "Calendar ID"} string? calendarId = ()) 
                                         returns @tainted Event|error { 
                                        //TODO : Handle optional calenderId
        string path = EMPTY_STRING;
        if (calendarId is string){
            path = check createUrl([LOGGED_IN_USER, CALENDARS, calendarId, EVENTS]);
        } else {
            path = check createUrl([LOGGED_IN_USER, EVENTS]);
        }
        log:printDebug(path.toString());
        return check self.httpClient->post(<@untainted>path, check eventMetadata.cloneWithType(json), targetType=Event);
    }

    # Update an event
    # This updates the properties of a Event object.
    # API doc : https://docs.microsoft.com/en-us/graph/api/event-update 
    #
    # + eventId - ID of an event.
    # + eventMetadata - Metadata related to Event that we are passing on input.  
    # + calendarId - Calendar ID of the calendar that you want to update the event. 
    # + return - `error` if failed.
    @display {label: "Update Event"}
    remote isolated function updateEvent(@display {label: "Event ID"} string eventId, 
                                         @display {label: "Event Metadata"} EventMetadata eventMetadata,
                                         @display {label: "Calendar ID"} string? calendarId = ()) 
                                         returns @tainted Event|error {
                                         //TODO : Handle optional calenderId
        string path = EMPTY_STRING;
        if (calendarId is string){
            path = check createUrl([LOGGED_IN_USER, CALENDARS, calendarId, EVENTS, eventId]);
        } else {
            path = check createUrl([LOGGED_IN_USER, EVENTS, eventId]);
        }
        return check self.httpClient->patch(<@untainted>path, check eventMetadata.cloneWithType(json), targetType=Event);
    }

    # Delete an event
    # This removes the specified event from the containing calendar.
    # API doc : https://docs.microsoft.com/en-us/graph/api/event-delete
    #
    # + eventId - ID of an event. 
    # + calendarId - Calendar ID of the calendar that you want to delete the event. 
    # + return - `error` if failed.
    @display {label: "Delete Event"}
    remote isolated function deleteEvent(@display {label: "Event ID"} string eventId, 
                                         @display {label: "Calendar ID"} string? calendarId = ()) 
                                         returns @tainted error? {
        string path = check createUrl([LOGGED_IN_USER, EVENTS, eventId]);
        http:Response response = check self.httpClient->delete(<@untainted>path);
        _ = check handleResponse(response);
    }
}

