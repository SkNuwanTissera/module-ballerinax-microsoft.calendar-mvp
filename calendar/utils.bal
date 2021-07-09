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
import ballerina/io;
import ballerina/log;

isolated function createUrl(string[] pathParameters, string? queryParameters = ()) returns string|error {
    string url = EMPTY_STRING;
    if (pathParameters.length() > ZERO) {
        foreach string element in pathParameters {
            if (!element.startsWith(FORWARD_SLASH)) {
                url = url + FORWARD_SLASH;
            }
            url += element;
        }
    }
    if (queryParameters is string) {
        url = url + QUESTION_MARK + queryParameters;
        io:println(url);
    }
    return url;
}

isolated function appendQueryOption(string queryParameter, string connectingString) returns string|error {
    string url = EMPTY_STRING;
    int? indexOfEqual = queryParameter.indexOf(EQUAL_SIGN);
    if (indexOfEqual is int) {
        string queryOptionName = queryParameter.substring(ZERO, indexOfEqual);
        string queryOptionValue = queryParameter.substring(indexOfEqual);
        if (queryOptionName.startsWith(DOLLAR_SIGN)) {
            if (validateOdataSystemQueryOption(queryOptionName.substring(1), queryOptionValue)) {
                url += connectingString + queryParameter;
            } else {
                return error(INVALID_QUERY_PARAMETER);
            }
        } else {
            // non Odata query parameters
            url += connectingString + queryParameter;
        }
    } else {
        return error(INVALID_QUERY_PARAMETER);
    }
    return url;
}

isolated function validateOdataSystemQueryOption(string queryOptionName, string queryOptionValue) returns boolean {
    boolean isValid = false;
    string[] characterArray = [];
    if (queryOptionName is SystemQueryOption) {
        isValid = true;
    } else {
        return false;
    }
    foreach string character in queryOptionValue {
        if (character is OpeningCharacters) {
            characterArray.push(character);
        } else if (character is ClosingCharacters) {
            _ = characterArray.pop();
        }
    }
    if (characterArray.length() == ZERO){
        isValid = true;
    }
    return isValid;
}

isolated function handleResponse(http:Response httpResponse) returns @tainted map<json>|error? {
    if (httpResponse.statusCode is http:STATUS_OK|http:STATUS_CREATED|http:STATUS_ACCEPTED) {
        json jsonResponse = check httpResponse.getJsonPayload();
        return <map<json>>jsonResponse;
    } else if (httpResponse.statusCode is http:STATUS_NO_CONTENT) {
        return;
    }
    json errorPayload = check httpResponse.getJsonPayload();
    string message = errorPayload.toString(); // Error should be defined as a user defined object
    return error (message);
}

# Get events by Id
#
# + httpClient - HTTP Client  
# + url - Formatted URL 
# + timeZone - Parameter Description  
# + contentType - Parameter Description
# + return - Return Value Description  
#
# + return - If successful return `Event`, else `error`
isolated function getEventById(http:Client httpClient, string url, string? timeZone, string? contentType) returns @tainted Event|error {
    http:Response response = check httpClient->get(url, preparePreferenceHeaderString(timeZone, contentType));
    io:println(response);
    json event = check handleResponse(response);
    return check event.cloneWithType(Event);
}

isolated function preparePreferenceHeaderString(string? timeZone, string? contentType) returns map<string> {
    map<string> header = {};
    if(timeZone is string && contentType is string) {
        header = {[PREFER] : string `outlook.timezone="${timeZone.toString()}", outlook.body-content-type="${contentType.toString()}"`};
    }
    else if (timeZone is string) {
        header = {[PREFER] : string `outlook.timezone="${timeZone.toString()}"`};
    }
    else if (contentType is string) {
        header = {[PREFER] : string `outlook.body-content-type="${contentType.toString()}"`};
    }
    log:printDebug(header.toString());
    return header;
}

# Sets required request headers.
# 
# + request - Request object reference
# + specificRequiredHeaders - Request headers as a key value map
isolated function setSpecificRequestHeaders(http:Request request, map<string> specificRequiredHeaders) {
    string[] keys = specificRequiredHeaders.keys();
    foreach string keyItem in keys {
        request.setHeader(keyItem, specificRequiredHeaders.get(keyItem));
    }
}
