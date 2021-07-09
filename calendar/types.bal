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

# Get the properties and relationships of the specified event object.
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
    string iCalUId?;
    OnlineMeetingInfo? onlineMeeting?;
    Recipient? organizer?;
    string originalStart?;
    readonly EventType 'type?;
    readonly string webLink?;
};

public type EventMetadata record {
    string? subject?;
    ItemBody body?;
    string bodyPreview?;
    string[] categories?;
    string originalStartTimeZone?;
    string originalEndTimeZone?;
    DateTimeTimeZone? 'start?;
    DateTimeTimeZone? end?;
    Location location?;
    Location[] locations?;
    Attendee[] attendees?;
    PatternedRecurrence? recurrence?;
    boolean allowNewTimeProposals?;
    boolean hasAttachments?;
    boolean hideAttendees?;
    boolean isAllDay?;
    boolean isOnlineMeeting?;
    boolean isReminderOn?;
    Importance importance?;
    int reminderMinutesBeforeStart?;
    boolean responseRequested?;
    ResponseStatus responseStatus?;
    Sensitivity sensitivity?;
    ShowAs showAs?;
    OnlineMeetingProviderType onlineMeetingProvider?;
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

public type Attendee record {
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
    ONLINE_MEETING_PROVIDER_TYPE_SKYPE_FOR_CONSUMER = "skypeForConsumer",
    ONLINE_MEETING_PROVIDER_TYPE_SKYPE_FOR_UNKNOWN = "unknown"
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

public enum AttendeeType {
    ATTENDEE_TYPE_REQUIRED = "required",
    ATTENDEE_TYPE_OPTIONAL = "optional",
    ATTENDEE_TYPE_RESOURCE = "resource"
}

public enum ContentType {
    CONTENT_TYPE_HTML = "html",
    CONTENT_TYPE_TEXT = "text"
}

public enum Importance {
    IMPORTANCE_LOW = "low",
    IMPORTANCE_NORMAL = "normal",
    IMPORTANCE_HIGH = "high"
}

public enum TimeZone {
    TIMEZONE_AF = "Afghanistan Standard Time",
    TIMEZONE_AX = "FLE Standard Time",
    TIMEZONE_AL = "Central Europe Standard Time",
    TIMEZONE_DZ = "W. Central Africa Standard Time",
    TIMEZONE_AS = "UTC-11",
    TIMEZONE_AD = "W. Europe Standard Time",
    TIMEZONE_AO = "W. Central Africa Standard Time",
    TIMEZONE_AI = "SA Western Standard Time",
    TIMEZONE_AQ = "Pacific SA Standard Time",
    TIMEZONE_AG = "SA Western Standard Time",
    TIMEZONE_AR = "Argentina Standard Time",
    TIMEZONE_AM = "Caucasus Standard Time",
    TIMEZONE_AW = "SA Western Standard Time",
    TIMEZONE_AU = "AUS Eastern Standard Time",
    TIMEZONE_AT = "W. Europe Standard Time",
    TIMEZONE_AZ = "Azerbaijan Standard Time",
    TIMEZONE_BS = "Eastern Standard Time",
    TIMEZONE_BH = "Arab Standard Time",
    TIMEZONE_BD = "Bangladesh Standard Time",
    TIMEZONE_BB = "SA Western Standard Time",
    TIMEZONE_BY = "Belarus Standard Time",
    TIMEZONE_BE = "Romance Standard Time",
    TIMEZONE_BZ = "Central America Standard Time",
    TIMEZONE_BJ = "W. Central Africa Standard Time",
    TIMEZONE_BM = "Atlantic Standard Time",
    TIMEZONE_BT = "Bangladesh Standard Time",
    TIMEZONE_VE = "Venezuela Standard Time",
    TIMEZONE_BO = "SA Western Standard Time",
    TIMEZONE_BQ = "SA Western Standard Time",
    TIMEZONE_BA = "Central European Standard Time",
    TIMEZONE_BW = "South Africa Standard Time",
    TIMEZONE_BV = "UTC",
    TIMEZONE_BR = "E. South America Standard Time",
    TIMEZONE_IO = "Central Asia Standard Time",
    TIMEZONE_BN = "Singapore Standard Time",
    TIMEZONE_BG = "FLE Standard Time",
    TIMEZONE_BF = "Greenwich Standard Time",
    TIMEZONE_BI = "South Africa Standard Time",
    TIMEZONE_CV = "Cape Verde Standard Time",
    TIMEZONE_KH = "SE Asia Standard Time",
    TIMEZONE_CM = "W. Central Africa Standard Time",
    TIMEZONE_CA = "Eastern Standard Time",
    TIMEZONE_KY = "SA Pacific Standard Time",
    TIMEZONE_CF = "W. Central Africa Standard Time",
    TIMEZONE_TD = "W. Central Africa Standard Time",
    TIMEZONE_CL = "Pacific SA Standard Time",
    TIMEZONE_CN = "China Standard Time",
    TIMEZONE_CX = "SE Asia Standard Time",
    TIMEZONE_CC = "Myanmar Standard Time",
    TIMEZONE_CO = "SA Pacific Standard Time",
    TIMEZONE_KM = "E. Africa Standard Time",
    TIMEZONE_CG = "W. Central Africa Standard Time",
    TIMEZONE_CD = "W. Central Africa Standard Time",
    TIMEZONE_CK = "Hawaiian Standard Time",
    TIMEZONE_CR = "Central America Standard Time",
    TIMEZONE_CI = "Greenwich Standard Time",
    TIMEZONE_HR = "Central European Standard Time",
    TIMEZONE_CU = "Eastern Standard Time",
    TIMEZONE_CW = "SA Western Standard Time",
    TIMEZONE_CY = "E. Europe Standard Time",
    TIMEZONE_CZ = "Central Europe Standard Time",
    TIMEZONE_TL = "Tokyo Standard Time",
    TIMEZONE_DK = "Romance Standard Time",
    TIMEZONE_DJ = "E. Africa Standard Time",
    TIMEZONE_DM = "SA Western Standard Time",
    TIMEZONE_DO = "SA Western Standard Time",
    TIMEZONE_EC = "SA Pacific Standard Time",
    TIMEZONE_EG = "Egypt Standard Time",
    TIMEZONE_SV = "Central America Standard Time",
    TIMEZONE_GQ = "W. Central Africa Standard Time",
    TIMEZONE_ER = "E. Africa Standard Time",
    TIMEZONE_EE = "FLE Standard Time",
    TIMEZONE_ET = "E. Africa Standard Time",
    TIMEZONE_FK = "SA Eastern Standard Time",
    TIMEZONE_FO = "GMT Standard Time",
    TIMEZONE_FJ = "Fiji Standard Time",
    TIMEZONE_FI = "FLE Standard Time",
    TIMEZONE_FR = "Romance Standard Time",
    TIMEZONE_GF = "SA Eastern Standard Time",
    TIMEZONE_PF = "Hawaiian Standard Time",
    TIMEZONE_TF = "West Asia Standard Time",
    TIMEZONE_GA = "W. Central Africa Standard Time",
    TIMEZONE_GM = "Greenwich Standard Time",
    TIMEZONE_GE = "Georgian Standard Time",
    TIMEZONE_DE = "W. Europe Standard Time",
    TIMEZONE_GH = "Greenwich Standard Time",
    TIMEZONE_GI = "W. Europe Standard Time",
    TIMEZONE_GR = "GTB Standard Time",
    TIMEZONE_GL = "Greenland Standard Time",
    TIMEZONE_GD = "SA Western Standard Time",
    TIMEZONE_GP = "SA Western Standard Time",
    TIMEZONE_GU = "West Pacific Standard Time",
    TIMEZONE_GT = "Central America Standard Time",
    TIMEZONE_GG = "GMT Standard Time",
    TIMEZONE_GN = "Greenwich Standard Time",
    TIMEZONE_GW = "Greenwich Standard Time",
    TIMEZONE_GY = "SA Western Standard Time",
    TIMEZONE_HT = "Eastern Standard Time",
    TIMEZONE_HM = "Mauritius Standard Time",
    TIMEZONE_HN = "Central America Standard Time",
    TIMEZONE_HK = "China Standard Time",
    TIMEZONE_HU = "Central Europe Standard Time",
    TIMEZONE_IS = "Greenwich Standard Time",
    TIMEZONE_IN = "India Standard Time",
    TIMEZONE_ID = "SE Asia Standard Time",
    TIMEZONE_IR = "Iran Standard Time",
    TIMEZONE_IQ = "Arabic Standard Time",
    TIMEZONE_IE = "GMT Standard Time",
    TIMEZONE_IL = "Israel Standard Time",
    TIMEZONE_IT = "W. Europe Standard Time",
    TIMEZONE_JM = "SA Pacific Standard Time",
    TIMEZONE_SJ = "W. Europe Standard Time",
    TIMEZONE_JP = "Tokyo Standard Time",
    TIMEZONE_JE = "GMT Standard Time",
    TIMEZONE_JO = "Jordan Standard Time",
    TIMEZONE_KZ = "Central Asia Standard Time",
    TIMEZONE_KE = "E. Africa Standard Time",
    TIMEZONE_KI = "UTC+12",
    TIMEZONE_KR = "Korea Standard Time",
    TIMEZONE_XK = "Central European Standard Time",
    TIMEZONE_KW = "Arab Standard Time",
    TIMEZONE_KG = "Central Asia Standard Time",
    TIMEZONE_LA = "SE Asia Standard Time",
    TIMEZONE_LV = "FLE Standard Time",
    TIMEZONE_LB = "Middle East Standard Time",
    TIMEZONE_LS = "South Africa Standard Time",
    TIMEZONE_LR = "Greenwich Standard Time",
    TIMEZONE_LY = "E. Europe Standard Time",
    TIMEZONE_LI = "W. Europe Standard Time",
    TIMEZONE_LT = "FLE Standard Time",
    TIMEZONE_LU = "W. Europe Standard Time",
    TIMEZONE_MO = "China Standard Time",
    TIMEZONE_MK = "Central European Standard Time",
    TIMEZONE_MG = "E. Africa Standard Time",
    TIMEZONE_MW = "South Africa Standard Time",
    TIMEZONE_MY = "Singapore Standard Time",
    TIMEZONE_MV = "West Asia Standard Time",
    TIMEZONE_ML = "Greenwich Standard Time",
    TIMEZONE_MT = "W. Europe Standard Time",
    TIMEZONE_IM = "GMT Standard Time",
    TIMEZONE_MH = "UTC+12",
    TIMEZONE_MQ = "SA Western Standard Time",
    TIMEZONE_MR = "Greenwich Standard Time",
    TIMEZONE_MU = "Mauritius Standard Time",
    TIMEZONE_YT = "E. Africa Standard Time",
    TIMEZONE_MX = "Central Standard Time (Mexico)",
    TIMEZONE_FM = "West Pacific Standard Time",
    TIMEZONE_MD = "GTB Standard Time",
    TIMEZONE_MC = "W. Europe Standard Time",
    TIMEZONE_MN = "Ulaanbaatar Standard Time",
    TIMEZONE_ME = "Central European Standard Time",
    TIMEZONE_MS = "SA Western Standard Time",
    TIMEZONE_MA = "Morocco Standard Time",
    TIMEZONE_MZ = "South Africa Standard Time",
    TIMEZONE_MM = "Myanmar Standard Time",
    TIMEZONE_NA = "Namibia Standard Time",
    TIMEZONE_NR = "UTC+12",
    TIMEZONE_NP = "Nepal Standard Time",
    TIMEZONE_NL = "W. Europe Standard Time",
    TIMEZONE_NC = "Central Pacific Standard Time",
    TIMEZONE_NZ = "New Zealand Standard Time",
    TIMEZONE_NI = "Central America Standard Time",
    TIMEZONE_NE = "W. Central Africa Standard Time",
    TIMEZONE_NG = "W. Central Africa Standard Time",
    TIMEZONE_NU = "UTC-11",
    TIMEZONE_NF = "Central Pacific Standard Time",
    TIMEZONE_KP = "Korea Standard Time",
    TIMEZONE_MP = "West Pacific Standard Time",
    TIMEZONE_NO = "W. Europe Standard Time",
    TIMEZONE_OM = "Arabian Standard Time",
    TIMEZONE_PK = "Pakistan Standard Time",
    TIMEZONE_PW = "Tokyo Standard Time",
    TIMEZONE_PS = "Egypt Standard Time",
    TIMEZONE_PA = "SA Pacific Standard Time",
    TIMEZONE_PG = "West Pacific Standard Time",
    TIMEZONE_PY = "Paraguay Standard Time",
    TIMEZONE_PE = "SA Pacific Standard Time",
    TIMEZONE_PH = "Singapore Standard Time",
    TIMEZONE_PN = "Pacific Standard Time",
    TIMEZONE_PL = "Central European Standard Time",
    TIMEZONE_PT = "GMT Standard Time",
    TIMEZONE_PR = "SA Western Standard Time",
    TIMEZONE_QA = "Arab Standard Time",
    TIMEZONE_RE = "Mauritius Standard Time",
    TIMEZONE_RO = "GTB Standard Time",
    TIMEZONE_RU = "Russian Standard Time",
    TIMEZONE_RW = "South Africa Standard Time",
    TIMEZONE_BL = "SA Western Standard Time",
    TIMEZONE_SH = "Greenwich Standard Time",
    TIMEZONE_KN = "SA Western Standard Time",
    TIMEZONE_LC = "SA Western Standard Time",
    TIMEZONE_MF = "SA Western Standard Time",
    TIMEZONE_PM = "Greenland Standard Time",
    TIMEZONE_VC = "SA Western Standard Time",
    TIMEZONE_WS = "Samoa Standard Time",
    TIMEZONE_SM = "W. Europe Standard Time",
    TIMEZONE_ST = "Greenwich Standard Time",
    TIMEZONE_SA = "Arab Standard Time",
    TIMEZONE_SN = "Greenwich Standard Time",
    TIMEZONE_RS = "Central Europe Standard Time",
    TIMEZONE_SC = "Mauritius Standard Time",
    TIMEZONE_SL = "Greenwich Standard Time",
    TIMEZONE_SG = "Singapore Standard Time",
    TIMEZONE_SX = "SA Western Standard Time",
    TIMEZONE_SK = "Central Europe Standard Time",
    TIMEZONE_SI = "Central Europe Standard Time",
    TIMEZONE_SB = "Central Pacific Standard Time",
    TIMEZONE_SO = "E. Africa Standard Time",
    TIMEZONE_ZA = "South Africa Standard Time",
    TIMEZONE_GS = "UTC-02",
    TIMEZONE_SS = "E. Africa Standard Time",
    TIMEZONE_ES = "Romance Standard Time",
    TIMEZONE_LK = "Sri Lanka Standard Time",
    TIMEZONE_SD = "E. Africa Standard Time",
    TIMEZONE_SR = "SA Eastern Standard Time",
    TIMEZONE_SZ = "South Africa Standard Time",
    TIMEZONE_SE = "W. Europe Standard Time",
    TIMEZONE_CH = "W. Europe Standard Time",
    TIMEZONE_SY = "Syria Standard Time",
    TIMEZONE_TW = "Taipei Standard Time",
    TIMEZONE_TJ = "West Asia Standard Time",
    TIMEZONE_TZ = "E. Africa Standard Time",
    TIMEZONE_TH = "SE Asia Standard Time",
    TIMEZONE_TG = "Greenwich Standard Time",
    TIMEZONE_TK = "Tonga Standard Time",
    TIMEZONE_TO = "Tonga Standard Time",
    TIMEZONE_TT = "SA Western Standard Time",
    TIMEZONE_TN = "W. Central Africa Standard Time",
    TIMEZONE_TR = "Turkey Standard Time",
    TIMEZONE_TM = "West Asia Standard Time",
    TIMEZONE_TC = "Eastern Standard Time",
    TIMEZONE_TV = "UTC+12",
    TIMEZONE_UM = "UTC-11",
    TIMEZONE_UG = "E. Africa Standard Time",
    TIMEZONE_UA = "FLE Standard Time",
    TIMEZONE_AE = "Arabian Standard Time",
    TIMEZONE_GB = "GMT Standard Time",
    TIMEZONE_US = "Pacific Standard Time",
    TIMEZONE_UY = "Montevideo Standard Time",
    TIMEZONE_UZ = "West Asia Standard Time",
    TIMEZONE_VU = "Central Pacific Standard Time",
    TIMEZONE_VA = "W. Europe Standard Time",
    TIMEZONE_VN = "SE Asia Standard Time",
    TIMEZONE_VI = "SA Western Standard Time",
    TIMEZONE_VG = "SA Western Standard Time",
    TIMEZONE_WF = "UTC+12",
    TIMEZONE_YE = "Arab Standard Time",
    TIMEZONE_ZM = "South Africa Standard Time",
    TIMEZONE_ZW = "South Africa Standard Time"
}

# Get the properties and relationships of the specified calendar object.
# Calendar Resource
public type Calendar record {
    *GeneratedCalendarData;
    *CalendarMetadata;
};

public type GeneratedCalendarData record {
    readonly string id;
    readonly string hexColor?;
    readonly string changeKey?;
};
public type CalendarMetadata record {
    string name?;
    boolean? isDefaultCalendar?;
    OnlineMeetingProviderType[] allowedOnlineMeetingProviders?;
    boolean canEdit?;
    boolean canShare?;
    boolean isRemovable?;
    boolean isTallyingResponses?;
    boolean canViewPrivateItems?;
    CalendarColor? color?;
    OnlineMeetingProviderType defaultOnlineMeetingProvider?;
    EmailAddress owner?;
};

public enum CalendarColor {
    CALENDAR_COLOR_AUTO = "auto",
    CALENDAR_COLOR_LIGHTBLUE = "lightBlue",
    CALENDAR_COLOR_LIGHT_GREEN = "lightGreen",
    CALENDAR_COLOR_LIGHT_ORANGE = "lightOrange",
    CALENDAR_COLOR_LIGHT_GRAY = "lightGray",
    CALENDAR_COLOR_LIGHT_YELLOW = "lightYellow",
    CALENDAR_COLOR_LIGHT_TEAL = "lightTeal",
    CALENDAR_COLOR_LIGHT_PINK = "lightPink",
    CALENDAR_COLOR_LIGHT_BROWN = "lightBrown",
    CALENDAR_COLOR_LIGHT_RED = "lightRed",
    CALENDAR_COLOR_MAX_COLOR = "maxColor"
}