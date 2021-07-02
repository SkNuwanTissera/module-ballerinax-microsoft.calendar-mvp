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

class EventStream {
    private Event[] currentEntries = [];
    private string nextLink;
    int index = 0;
    private final http:Client httpClient;
    private final string path;

     isolated function init(http:Client httpClient, string path) returns @tainted error? {
        self.httpClient = httpClient;
        self.path = path;
        self.nextLink = EMPTY_STRING;
        self.currentEntries = check self.fetchRecordsInitial();
    }

    public isolated function next() returns @tainted record {| Event value; |}|error? {
        if(self.index < self.currentEntries.length()) {
            record {| Event value; |} singleRecord = {value: self.currentEntries[self.index]};
            self.index += 1;
            return singleRecord;
        }
        // This code block is for retrieving the next batch of records when the initial batch is finished.
        if (self.nextLink != EMPTY_STRING) {
            self.index = 0;
            self.currentEntries = check self.fetchRecordsNext();
            record {| Event value; |} singleRecord = {value: self.currentEntries[self.index]};
            self.index += 1;
            return singleRecord;
        }
    }

    isolated function fetchRecordsInitial() returns @tainted Event[]|error {
        http:Response response = check self.httpClient->get(self.path);
        map<json>|string? handledResponse = check handleResponse(response);
        return check self.getAndConvertToEventArray(response);
    }
    
    isolated function fetchRecordsNext() returns @tainted Event[]|error {
        http:Client nextPageClient = check new (self.nextLink);
        http:Response response = check nextPageClient->get(EMPTY_STRING);
        return check self.getAndConvertToEventArray(response);
    }

    isolated function getAndConvertToEventArray(http:Response response) returns @tainted Event[]|error {
        Event[] events = [];
        map<json>|string? handledResponse = check handleResponse(response);
        if (handledResponse is map<json>) {
            self.nextLink = let var link = handledResponse["@odata.nextLink"] in link is string ? link : EMPTY_STRING;
            json values = check handledResponse.value;
            if (values is json[]) {
                foreach json item in values {
                    Event convertedItem = check item.cloneWithType(Event);
                    events.push(convertedItem);
                }
                return events;
            } else {
                return error(INVALID_PAYLOAD);
            }
        } else {
            return error(INVALID_RESPONSE);
        }
    }
}