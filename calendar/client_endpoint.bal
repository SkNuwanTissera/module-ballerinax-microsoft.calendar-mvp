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
// import ballerina/log;

# OneDrive Client Object for executing drive operations.
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

    // ************************************* Operations on a Event resource ********************************************
    // The Event resource is the top-level object representing a event in outlook.

    # Get event by proving the ID
    # 
    # + return - An record `Event` if success. Else `Error`.
    @display {label: "Get Event"}
    remote isolated function getEvent() returns @tainted Event|error? {
        return {id:"4243"};
    }
}

