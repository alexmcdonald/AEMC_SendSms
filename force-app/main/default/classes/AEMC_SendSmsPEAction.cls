/* 
 * ====================
 * AEMC_SendSmsPEAction
 * ====================
 * 
 * This Invocable Action is called by Salesforce Account Engagement (fka Pardot) to start the process of sending an SMS 
 * through Salesforce Marketing Cloud MobileConnect.
 * 
 * The action creates a Platform Event with the message details. The PE is processed by an auto-launched Flow (AEMC_Send_SMS)
 * which triggers the send through the Marketing Cloud API.
 * 
 * The reason for this "double-handling" through the use of the Platform Event is because when writing this sample code,
 * nothing I did worked when trying to trigger the send directly from the Account Engagement action, there was some sort of user
 * permission that the triggering user didn't have that prevented it.  Triggering it via a Platform Event changed the user
 * context and circumvented the problem.
 * 
 * It's always possible that this step isn't needed anymore, or won't be after a future release.
 * 
 * --
 * 
 * Public Repository: https://github.com/alexmcdonald/AEMC_SendSms
 * 
 * NB: This sample code is provided under the terms of the Creative Commons Zero (CC0) license, which means the author has waived 
 * all copyright and related rights in the code. It is made available for educational and reference purposes, but the author 
 * makes no warranties or guarantees regarding its accuracy, suitability for any particular purpose, or its fitness for use 
 * in specific applications.
 * 
 * Users are encouraged to use and modify the code at their own risk, and the author shall not be held liable for any damages 
 * or issues arising from its use. Always exercise caution and due diligence when incorporating this code into your projects.
 * 
 * --
 * 
 */


public class AEMC_SendSmsPEAction {

    @InvocableMethod(label='AEMC: Send SMS Platform Event')
    public static void execute(List<InputData> inputList) {
        
        System.debug('* Creating AEMC_SMS Platform Event');
        
        InputData input = inputList[0];
        
        AEMC_SendSms__e ev = new AEMC_SendSms__e();
        ev.mobileNumber__c = input.mobileNumber;
        ev.messageContent__c = input.messageContent.left(160);
        ev.reformatNumber__c = (!String.isBlank(input.reformatNumber) && input.reformatNumber == '1') ? true : false;
        ev.countryCode__c = input.countryCode;
        
        System.debug('** Event Record: ' + ev);
        
        Database.SaveResult result = EventBus.publish(ev);
        System.debug('** Save Result: ' + result);
        
    }
    
    public class InputData {
        
        @InvocableVariable public String mobileNumber;
        @InvocableVariable public String messageContent;
        @InvocableVariable public String reformatNumber;
        @InvocableVariable public String countryCode;
        
    }
}
