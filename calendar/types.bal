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

# Event Resource
public type Event record {
    *GeneratedEventData;
    *EventMetadata;
};

public type GeneratedEventData record {
    readonly string id;
    string changeKey?;
    string createdDateTime?;
    string? occurrenceId?;
    string? transactionId?;
    string? seriesMasterId?;
    readonly string? onlineMeetingUrl?;
    readonly string iCalUId;
    OnlineMeetingInfo onlineMeetingInfo?;
    OnlineMeetingProviderType onlineMeetingProviderType?;
    Recipient organizer?;
    string originalEndTimeZone?;
    string originalStart?;
    string originalStartTimeZone?;
    PatternedRecurrence? recurrence?;
    readonly EventType 'type?;
    readonly string webLink?;
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
    boolean hasAttachments?;
    boolean hideAttendees?;
    int reminderMinutesBeforeStart?;
    boolean responseRequested?;
    ResponseStatus responseStatus?;
    Sensitivity sensitivity?;
    ShowAs showAs?;

};

public type PatternedRecurrence record {
    RecurrencePattern pattern?;
    RecurrenceRange range?;
};

public type RecurrenceRange record {
    string endDate?;
    int numberOfOccurrences?;
    string recurrenceTimeZone?;
    string startDate?;
    RecurrenceRangeType 'type?;
};

public type Recipient record {
    EmailAddress emailAddress?;
};

public type OnlineMeetingInfo record {
    string conferenceId?;
    string joinUrl?;
    Phone phones?;
    string quickDial?;
    string[] tollFreeNumbers?;
    string tollNumber?;
};

public type Phone record {
    string number?;
    PhoneType 'type?;
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

public enum PhoneType {
    PHONE_TYPE_HOME = "home",
    PHONE_TYPE_BUSINESS = "business",
    PHONE_TYPE_MOBILE = "mobile",
    PHONE_TYPE_OTHER = "other",
    PHONE_TYPE_ASSISTANT = "assistant",
    PHONE_TYPE_HOME_FAX = "homeFax",
    PHONE_TYPE_BUSINESS_FAX = "businessFax",
    PHONE_TYPE_OTHER_FAX = "otherFax",
    PHONE_TYPE_PAGER = "pager",
    PHONE_TYPE_RADIO = "radio"
}

public enum OnlineMeetingProviderType {
    ONLINE_MEETING_PROVIDER_TYPE_TEAMS_FOR_BUSINESS = "teamsForBusiness",
    ONLINE_MEETING_PROVIDER_TYPE_SKYPE_FOR_BUSINESS = "skypeForBusiness",
    ONLINE_MEETING_PROVIDER_TYPE_SKYPE_FOR_CONSUMER = "skypeForConsumer"
}

public enum RecurrenceRangeType {
    RECURRENCE_RANGE_TYPE_END_DATE = "endDate",
    RECURRENCE_RANGE_TYPE_NO_END = "noEnd",
    RECURRENCE_RANGE_TYPE_NUMBERED = "numbered"
}

public enum RecurrencePattern {
    RECURRENCE_PATTERN_DAILY = "daily",
    RECURRENCE_PATTERN_WEEKLY = "weekly",
    RECURRENCE_PATTERN_ABSOLUTE_MONTHLY = "absoluteMonthly",
    RECURRENCE_PATTERN_RELATIVE_MONTHLY = "relativeMonthly",
    RECURRENCE_PATTERN_ABSOLUTE_YEARLY = "absoluteYearly",
    RECURRENCE_PATTERN_RELATIVE_YEARLY = "relativeYearly"
}

public enum Sensitivity {
    SENSITIVITY_NORMAL = "normal",
    SENSITIVITY_PERSONAL = "personal",
    SENSITIVITY_PRIVATE = "private",
    SENSITIVITY_CONFIDENTIAL = "confidential"
}

public enum ShowAs {
    SHOW_AS_FREE = "free",
    SHOW_AS_TENTATIVE = "tentative",
    SHOW_AS_BUSY = "busy",
    SHOW_AS_OOF = "oof",
    SHOW_AS_WORKING_ELSE_WHERE = "workingElsewhere",
    SHOW_AS_UNKNOWN = "unknown"
}

public enum EventType {
    EVENT_TYPE_SINGLE_INSTANCE = "singleInstance",
    EVENT_TYPE_OCCURRENCE = "occurrence",
    EVENT_TYPE_EXCEPTION = "exception",
    EVENT_TYPE_SERIES_MASTER = "seriesMaster"
}