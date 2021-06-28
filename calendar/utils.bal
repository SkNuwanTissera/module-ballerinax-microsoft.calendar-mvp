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
// import ballerina/io;
// import ballerina/regex;

isolated function createUrl(string[] pathParameters, string[] queryParameters = []) returns string|error {
    string url = EMPTY_STRING;
    if (pathParameters.length() > ZERO) {
        foreach string element in pathParameters {
            if (!element.startsWith(FORWARD_SLASH)) {
                url = url + FORWARD_SLASH;
            }
            url += element;
        }
    }
    if (queryParameters.length() > ZERO) {
        url = url + check appendQueryOption(queryParameters[ZERO], QUESTION_MARK);
        foreach string element in queryParameters.slice(1, queryParameters.length()) {
            url += check appendQueryOption(element, AMPERSAND);
        }
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

isolated function getEventById(http:Client httpClient, string url) returns @tainted Event|error {
    http:Response response = check httpClient->get(url);
    map<json>|string? event = check handleResponse(response);
    if (event is map<json>) {
        return check event.cloneWithType(Event);
    } else {
        return error (INVALID_RESPONSE);
    }
}