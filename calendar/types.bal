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

# Represents configuration parameters to create Microsoft Calendar.
#
# + clientConfig - OAuth client configuration
# + secureSocketConfig - SSH configuration
@display{label: "Connection Config"} 
public type Configuration record {
    http:BearerTokenConfig|http:OAuth2RefreshTokenGrantConfig clientConfig;
    http:ClientSecureSocket secureSocketConfig?;
};

# An abstract resource that contains a common set of properties shared among several other resources types.
#
public type Event record {
    *GeneratedEventData;
    *EventMetadata;
};

public type GeneratedEventData record {
    string id;
    string changeKey?;
    string createdDateTime?;
};

public type EventMetadata record {
    string? subject?;
    ItemBody body?;
    string bodyPreview?;
    string[] categories?;
    DateTimeTimeZone 'start?;
    DateTimeTimeZone end?;
    Location location?;
    Attendees[] attendees?;
    boolean allowNewTimeProposals?;
    string? transactionId?;
    string? seriesMasterId?;
    string? onlineMeetingUrl?;
    string? occurrenceId?;
    boolean hasAttachments?;
    boolean hideAttendees?;
};

public type ItemBody record {
    string contentType?;
    string content?;
};

public type DateTimeTimeZone record {
    string dateTime?;
    string timeZone?;
};

public type Location record {
    PhysicalAddress address?;
    OutlookGeoCoordinates coordinates?;
    string displayName?;
    string locationEmailAddress?;
    string locationUri?;
    LocationType locationType?;
};

public type PhysicalAddress record {
    string city?;
    string countryOrRegion?;
    string postalCode?;
    string state?;
    string street?;
};

public type OutlookGeoCoordinates record {
    float accuracy?;
    float altitude?;
    float altitudeAccuracy?;
    float latitude?;
    float longitude?;
};

public type Attendees record {
    EmailAddress emailAddress?;
    TimeSlot proposedNewTime?;
    ResponseStatus status?;
    string 'type?;
};

public type EmailAddress record {
    string address?;
    string name?;
};

public type TimeSlot record {
    DateTimeTimeZone 'start?;
    DateTimeTimeZone end?;
};

public type ResponseStatus record {
    ResponseType response?;
    string time?;
};

public enum ResponseType {
    RESPONSE_NONE = "none",
    RESPONSE_ORGANIZER = "organizer",
    RESPONSE_TENTATIVELY_ACCEPTED = "tentativelyAccepted",
    RESPONSE_ACCEPTED = "accepted",
    RESPONSE_DECLINED = "declined",
    RESPONSE_NOT_RESPONDED = "notResponded"
}

public enum LocationType {
    LOCATION_TYPE_DEFAULT = "default",
    LOCATION_TYPE_CONFERENCE_ROOM = "conferenceRoom",
    LOCATION_TYPE_HOME_ADDRESS = "homeAddress",
    LOCATION_TYPE_BUSINESS_ADDRESS = "businessAddress",
    LOCATION_TYPE_GEO_COORDINATES = "geoCoordinates",
    LOCATION_TYPE_STREET_ADDRESS = "streetAddress",
    LOCATION_TYPE_HOTEL = "hotel",
    LOCATION_TYPE_RESTAURANT = "restaurant",
    LOCATION_TYPE_LOCAL_BUSINESS = "localBusiness",
    LOCATION_TYPE_POSTAL_ADDRESS = "postalAddress"
}