Ballerina Connector For Microsoft Calendar
===================

[![Build Status](https://github.com/ballerina-platform/module-ballerinax-microsoft.calendar/workflows/CI/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-msgraph-calendar/actions?query=workflow%3ACI)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-microsoft.calendar.svg)](https://github.com/ballerina-platform/module-ballerinax-msgraph-calendar/commits/master)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Connects to Microsoft Calendar using Ballerina.

- [Microsoft Calendar Connector]
    - [Introduction](#introduction)
        - [What is Microsoft Calendar](#what-is-microsoft-calendar)
        - [Key features of Microsoft Calendar](#key-features-of-microsoft-calendar)
        - [Connector Overview](#connector-overview)
    - [Prerequisites](#prerequisites)
        - [Obtaining tokens](#obtaining-tokens)
        - [Add project configurations file](#add-project-configurations-file)
    - [Supported versions & limitations](#supported-versions-&-limitations)
    - [Quickstart](#quickstart)
    - [Samples](#samples)
    - [Building from the Source](#building-from-the-source)
    - [Contributing to Ballerina](#contributing-to-ballerina)
    - [Code of Conduct](#code-of-conduct)
    - [Useful Links](#useful-links)

# Introduction
## What is Microsoft Calendar?
[Microsoft Calendar](https://support.microsoft.com/en-us/office/introduction-to-the-outlook-calendar-d94c5203-77c7-48ec-90a5-2e2bc10bd6f8) 
is composed of the calendar and scheduling component of Outlook that is fully integrated with email, contacts, and other 
features. Just as you write in a notebook, you can click any time slot in the Outlook Calendar and start typing. 
By using the Calendar you can create appointments and events, organize meetings, view group schedules, and much more.

<p align="center">
<img src="./docs/images/outlook-calendar.png?raw=true" alt="Calendar"/>
</p>

## Key features of Microsoft Calendar
- [Create appointments and events](https://support.microsoft.com/en-us/office/create-or-schedule-an-appointment-be84396a-0903-4e25-b31c-1c99ce0dacf2)  
- [Organize meetings](https://support.microsoft.com/en-us/office/schedule-a-meeting-with-other-people-5c9877bc-ab91-4a7c-99fb-b0b68d7ea94f)
- [View group schedules](https://support.microsoft.com/en-us/office/schedule-a-meeting-with-other-people-5c9877bc-ab91-4a7c-99fb-b0b68d7ea94f)
- [View calendars side-by-side](https://support.microsoft.com/en-us/office/view-multiple-calendars-at-the-same-time-fffa8783-0556-4ea1-ba62-3ed8a95a903c) 
- [View calendars on top of one another in overlay view](https://support.microsoft.com/en-us/office/view-multiple-calendars-at-the-same-time-fffa8783-0556-4ea1-ba62-3ed8a95a903c) 
- [Send calendars to anyone through email](https://support.microsoft.com/en-us/office/share-an-outlook-calendar-with-other-people-353ed2c1-3ec5-449d-8c73-6931a0adab88)   
- [Manage another user's calendar](https://support.microsoft.com/en-us/office/manage-another-person-s-mail-and-calendar-items-afb79d6b-2967-43b9-a944-a6b953190af5)     

## Connector Overview
Ballerina connector for Microsoft Calendar is connecting to Calendar file storage API in Microsoft Graph v1.0 via Ballerina 
language easily. It provides capability to perform basic drive functionalities including as Uploading, Downloading, 
Sharing files and folders which have been stored on Microsoft Calendar programmatically. 

The connector is developed on top of Microsoft Graph is a REST web API that empowers you to access Microsoft Cloud 
service resources. This version of the connector only supports the access to the resources and information of a specific 
account (currently logged in user).

# Prerequisites
- Microsoft Account
- Access to Azure Portal
- Java 11 installed - Java Development Kit (JDK) with version 11 is required
- [Ballerina SL Beta 1](https://ballerina.io/learn/user-guide/getting-started/setting-up-ballerina/installation-options/) installed 

## Obtaining tokens 
<!-- TODO: Add images & update with scopes --> 
- Create an Microsoft account.
- Sign into Azure Portal - App Registrations. (You can use your personal, work or school account to register the app)

- Obtaining OAuth2 credentials <br/>
    To get an access token you need to register your app with microsoft identity platform via Azure Portal. <br/>
    **(The access token contains information about your app and the permissions it has for the resources and APIs 
    available through Microsoft Graph. To get an access token, your app must be registered with the Microsoft 
    identity platform and be authorized by either a user or an administrator for access to the Microsoft Graph 
    resources it needs.)**

    Before your app can get a token from the Microsoft identity platform, it must be registered in the Azure portal. 
    Registration integrates your app with the Microsoft identity platform and establishes the information that it 
    uses to get tokens
    1. App Id
    2. Redirect URL
    3. App Secret <br/>

    **Step 1:** Register a new application in your Azure AD tenant.<br/>
    - In the App registrations page, click **New registration** and enter a meaningful name in the name field.
    - In the **Supported account types** section, select Accounts in any organizational directory (Any Azure AD 
    directory - Multi-tenant) and personal Microsoft accounts (e.g., Skype, Xbox, Outlook.com). Click Register to 
    create the application.
    - Provide a **Redirect URI** if necessary.

        ![Obtaining Credentials Step 1](docs/images/s1.png) 
    - Copy the Application (client) ID to fill `<MS_CLIENT_ID>`. This is the unique identifier for your app.

        ![Obtaining Credentials Step 1](docs/images/s2.png)

    **Step 2:** Create a new client secret.<br/>
    - Under **Certificates & Secrets**, create a new client secret to fill `<MS_CLIENT_SECRET>`. This requires providing 
    a description and a period of expiry. Next, click Add.

        ![Obtaining Credentials Step 2](docs/images/s3.png)

    **Step 3:** Add necessary scopes/permissions.<br/>
    - In an OpenID Connect or OAuth 2.0 authorization request, an app can request the permissions it needs by using the 
    scope query parameter.
    - Some high-privilege permissions in Microsoft resources can be set to admin-restricted. So, if we want to access 
    such kind of resources, an organization's administrator must consent to those scopes on behalf of the organization's 
    users.
 
        ![Obtaining Credentials Step 3](docs/images/s4.png)

    **Step 4:** Obtain the authorization endpoint and token endpoint by opening the `Endpoints` tab in the application 
    overview. <br/>
    - The **OAuth 2.0 token endpoint (v2)** can be used as the value for `<MS_REFRESH_URL>`

        ![Obtaining Credentials Step 4](docs/images/s5.png)

    - In a new browser, enter the below URL by replacing the <MS_CLIENT_ID> with the application ID.

        ```
        https://login.microsoftonline.com/common/oauth2/v2.0/authorize?client_id=<MS_CLIENT_ID>&response_type=code&redirect_uri=https://oauth.pstmn.io/v1/browser-callback&response_mode=query&scope=openid offline_access https://graph.microsoft.com/Files.ReadWrite.All
        ```
    
    - This will prompt you to enter the username and password for signing into the Azure Portal App.
    - Once the username and password pair is successfully entered, this will give a URL as follows on the browser address 
    bar.
        ```
        https://login.microsoftonline.com/common/oauth2/nativeclient?code=M95780001-0fb3-d138-6aa2-0be59d402f32
        ```
    - Copy the code parameter (M95780001-0fb3-d138-6aa2-0be59d402f32 in the above example) and in a new terminal, enter 
    the following cURL command by replacing the <MS_CODE> with the code received from the above step. The <MS_CLIENT_ID> 
    and <MS_CLIENT_SECRET> parameters are the same as above.
        ```
        curl -X POST --header "Content-Type: application/x-www-form-urlencoded" --header "Host:login.microsoftonline.com" -d "client_id=<MS_CLIENT_ID>&client_secret=<MS_CLIENT_SECRET>&grant_type=authorization_code&redirect_uri=https://login.microsoftonline.com/common/oauth2/nativeclient&code=<MS_CODE>&scope=Files.ReadWrite openid User.Read Mail.Send Mail.ReadWrite offline_access" https://login.microsoftonline.com/common/oauth2/v2.0/token
        ```
        
    - The above cURL command should result in a response as follows.
        ```
        {
            "token_type": "Bearer",
            "scope": "Files.ReadWrite openid User.Read Mail.Send Mail.ReadWrite",
            "expires_in": 3600,
            "ext_expires_in": 3600,
            "access_token": "<MS_ACCESS_TOKEN>",
            "refresh_token": "<MS_REFRESH_TOKEN>",
            "id_token": "<ID_TOKEN>"
        }
        ```
    **More information about OAuth2 tokens can be found here:** <br/>
    https://docs.microsoft.com/en-us/graph/auth-register-app-v2 <br/>
    https://docs.microsoft.com/en-au/azure/active-directory/develop/active-directory-v2-protocols#endpoints <br/>

## Add project configurations file
Add the project configuration file by creating a `Config.toml` file under the root path of the project structure.
This file should have following configurations. Add the tokens obtained in the previous steps to the `Config.toml` file.

#### Config.toml
```ballerina
[ballerinax.microsoft.calendar]
refreshUrl = <MS_REFRESH_URL>
refreshToken = <MS_REFRESH_TOKEN>
clientId = <MS_CLIENT_ID>
clientSecret = <MS_CLIENT_SECRET>
scopes = [<MS_NECESSARY_SCOPES>]
```
# Supported versions & limitations
## Supported Versions
|                                                                                    | Version               |
|------------------------------------------------------------------------------------|-----------------------|
| Ballerina Language Version                                                         | **Swan Lake Beta 1** |
| [Microsoft Graph API](https://docs.microsoft.com/en-us/graph/overview) Version     | **v1.0**              |
| Java Development Kit (JDK)                                                         | 11                    |

## Limitations
- Connector only allows to perform functions behalf of the currently logged in user.
- Only the operations which are supported in personal Microsoft account is supported.