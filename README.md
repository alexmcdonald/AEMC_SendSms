# AEMC - Send SMS from Salesforce Account Engagement #

This repo contains sample code to demonstrate how to trigger an SMS message from Salesforce Account Engagement (fka Pardot), specifically as part of an Engagement Studio Program step.

The SMS message is sent using Salesforce Marketing Cloud MobileConnect.  For this sample code to work, you need to have a subscription of both Salesforce Account Engagement, and Salesforce Marketing Cloud MobileConnect.
&nbsp;

&nbsp;

### Pre-requisites ###
* Account Engagement (fka Pardot) must be active in the org, and of an edition that supports External Actions
* External Actions must be enabled
* Access to a Salesforce Marketing Cloud environment with MobileConnect and an active phone number (long code) in your region
* You need to be an administrator in both your Salesforce org and the Account Engagement tenant
&nbsp;

&nbsp;

### Disclaimer ###
> [!WARNING]
>This code is released as sample code only, and is not warranted in any way by me or any current or future employer.  It is provided under the terms of the Creative Commons Zero (CC0) license, which means the author has waived all copyright and related rights in the code. It is made available for educational and reference purposes, but the author makes no warranties or guarantees regarding its accuracy, suitability for any particular purpose, or its fitness for use in specific applications.
>
>Users are encouraged to use and modify the code at their own risk, and the author shall not be held liable for any damages or issues arising from its use. Always exercise caution and due diligence when incorporating this code into your projects.
&nbsp;

&nbsp;

## Setup ##

### Marketing Cloud Setup: ###
1. Log in to your Marketing Cloud account ([mc.exacttarget.com](https://mc.exacttarget.com)), then click on your name and go to Setup.  Expand Platform Tools / Apps and click on Installed Packages.

![mc-package-1](https://github.com/alexmcdonald/AEMC_SendSms/assets/3958480/95a564a2-2550-40d7-8499-e819088966dd)

2. Create a new package, name it what you want and Save.  Click Add Component, and add API Integration.  Click Next, and select Server-to-Server.  Click Next again, and select all the options for SMS (Read, Write, Send).

<img width="627" alt="mc-package-2" src="https://github.com/alexmcdonald/AEMC_SendSms/assets/3958480/577073f6-5ddc-4432-b80a-7c3767b32e7e">

3. Click Save, and make note of the Client Id, Client Secret, and the prefix for the URIs (ie. https://PREFIX.auth.marketingcloudapis.com/).  Also note down the MID for the MC Business Unit you're using, by hovering over the BU name in the top right corner.

<img width="1250" alt="mc-package-3" src="https://github.com/alexmcdonald/AEMC_SendSms/assets/3958480/2098b784-69f7-4fa8-86c5-d73a24d1b7b0">
<img width="410" alt="mc-package-4" src="https://github.com/alexmcdonald/AEMC_SendSms/assets/3958480/43972478-1c92-4623-8f59-2f65e688ebb5">

4. Open Mobile Studio / MobileConnect, click on the Administration tab and confirm you've got a mobile number (Long Code) assigned.  Click on the number. Create a new keyword (eg. _AE_TRIGGER_) by typing it into the box on the right.

![mc-mobileconnect-1](https://github.com/alexmcdonald/AEMC_SendSms/assets/3958480/dc1cf13e-78ea-4566-b394-e118aba79516)

5. Click on the Overview tab, then click Create Message.  Click Text Response, call it something descriptive, select your long code, and select the keyword you just created.  Click next a few times to eventually save the message, then click _Schedule_ to activate the message.

<img width="1512" alt="mc-mobileconnect-2" src="https://github.com/alexmcdonald/AEMC_SendSms/assets/3958480/711c3ebf-75f0-4b69-8d28-80814285e54d">

6. On the Overview tab, click Create Message again, and this time click Outbound.  Give it a name, select your Long code, leave the From Name as your long code, and change the Send Method to API Trigger.  Click Next and enter a default outbound message, doesn't really matter what as this would usually be over-ridden in the External Action.  Set the Next Keyword to your created keyword (this is really important), then Save and Activate the message.  Take note of the Api Key that is displayed, if you forget to you can click into the message from the Overview screen to find it again.

<img width="1512" alt="mc-mobileconnect-3" src="https://github.com/alexmcdonald/AEMC_SendSms/assets/3958480/9b8e5df9-b0cf-4d98-bcc0-e2277c4bfc0c">
<img width="1512" alt="mc-mobileconnect-4" src="https://github.com/alexmcdonald/AEMC_SendSms/assets/3958480/ecfdd62c-91e1-453c-8368-5bc52e25afec">
<img width="1512" alt="mc-mobileconnect-5" src="https://github.com/alexmcdonald/AEMC_SendSms/assets/3958480/3a147050-bbb3-44ae-88aa-063e00cb3422">


### Salesforce Setup: ###
1. In your Salesforce Org, Go to Setup / Permission Sets.  Find the _AEMC: Send SMS Permissions_ permission set, and click into it.  Click on the Manage Assignments button, and then Add Assignment.  Select yourself (change the list view to All Users if need be) then click Next, then click Assign.

![sf-ps-assignment-1](https://github.com/alexmcdonald/AEMC_SendSms/assets/3958480/cca7b245-f442-4e27-803e-f697b647df2e)

2. Add two more assignments, one for the B2BMA Integration User, and the other for the Automated Process user.  Find these by changing the list view to All Users and then using the "Search this list" box.

![sf-ps-assignment-2](https://github.com/alexmcdonald/AEMC_SendSms/assets/3958480/91b352a8-84da-417a-8e88-982eb1ebda10)

3. Open the _AEMC: Send SMS_ flow from Setup / Flows.  Click into the Send SMS action, and adjust:
    * the API Prefix, Client Id, and Client Secret to match your Marketing Cloud API creds.
    * the MID to the Marketing Cloud Business Units MID
    * the SMS Message API key and Message Keyword, from the MobileConnect Outbound SMS message definition
    * and if using ApiLayer, your (freemium) APILayer.com number verification API key (https://apilayer.com/marketplace/number_verification-api)
    * .... then click the **Done** button, **Save As** the flow as a new version, and **Activate** it. 

![sf-flow-1](https://github.com/alexmcdonald/AEMC_SendSms/assets/3958480/ee843993-9dfe-438d-b12e-4c557e977f76)

4. Go to Setup / Remote Site Settings, and find the three settings starting with AEMC_.  Change the two MC_APIs keys to reflect the details for your MC orgs API settings.

![sf-remote-1](https://github.com/alexmcdonald/AEMC_SendSms/assets/3958480/e7d82fd9-b4d7-4c96-ab90-22f0ed5b8ef1)

5. In Setup, Quick Find "Marketing App Extensions".  Create a new extension and activate it, then change to its related list and create a new External Action.  In the **Invocable Action** field, select the AEMC_SendSmsPEAction.  ~~In the Invocable Action Schema, locate the section for **reformatNumber**, and change it's type from "int" to "number", and it's value from "" to either "1" (do reformat using APILayer callout) or "0" (don't reformat).~~ [THIS STEP HAS BEEN REMOVED, IGNORE THE HIGHLIGHTED TEXT IN THE SCREENSHOT BELOW]

Then select the _Active in Automations_ checkbox, and Save the action.

![sf-me-1](https://github.com/alexmcdonald/AEMC_SendSms/assets/3958480/767cab8d-b5aa-4625-a97d-a8e7dcf42449)

6. Navigate back to the Marketing App Extensions Related Lists, and create a **New** Business Unit Assignment.  Associate the extension with one or BUs that you wish to use the Send SMS action from.

<img width="1512" alt="sf-me-2" src="https://github.com/alexmcdonald/AEMC_SendSms/assets/3958480/272b0646-3228-4775-a523-f05c8be3a0b8">

7. Now you can add the external actions to your Engagement Studio Automations.  Use [handlebars merge syntax](https://help.salesforce.com/s/articleView?id=sf.pardot_handlebars_merge_fields.htm&type=5) such as `{{Recipient.Phone}}` to insert the prospects phone number.

![sf-ae-1](https://github.com/alexmcdonald/AEMC_SendSms/assets/3958480/eb6fd3e6-9c75-4699-9fc7-f28a72ceb27b)
<img width="320" alt="sf-ae-2" src="https://github.com/alexmcdonald/AEMC_SendSms/assets/3958480/baa93055-1074-4253-872c-9c5db448a903">

&nbsp;

&nbsp;

&nbsp;

If you run into difficulties, please reach out:
[github.com/alexmcdonald/AEMC_SendSms](https://github.com/alexmcdonald/AEMC_SendSms)

