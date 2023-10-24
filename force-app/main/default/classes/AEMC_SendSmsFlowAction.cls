/*
 * ======================
 * AEMC_SendSmsFlowAction
 * ======================
 * 
 * This Invocable Action is called from the AEMC_Send_SMS Flow.
 * 
 * It collects all the config inputs and the message details, and then enqueues a job to send the SMS asynchronously.
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

public without sharing class AEMC_SendSmsFlowAction {
    
    @InvocableMethod(label='AEMC: Send SMS') 
    public static List<String> execute(List<InputData> inputList) {
        
        InputData input = inputList[0];        
        System.debug('* Send SMS Flow Action: '+input);       
        String jobId = System.enqueueJob(new AEMC_SendSmsQueueable(input));
        return new List<String>{jobId};
            
    }
    
    public class InputData {

		// SFMC Access Token Inputs        
        @InvocableVariable(required=true label='_SFMC API Prefix' description='Org-specific prefix to the SFMC APIs') public String apiPrefix;
        @InvocableVariable(required=true label='_SFMC Client Id' description='Client Id to authenticate to the SFMC APIs') public String clientId;
        @InvocableVariable(required=true label='_SFMC Client Secret' description='Client Secret to authenticate to the SFMC APIs') public String clientSecret;
        @InvocableVariable(required=true label='_SFMC MID' description='Primary MID (tenant identifier) for the Marketing Cloud Org') public String mID;
        @InvocableVariable(required=true label='_SFMC Scope' description='Specified scope for access to the SFMC APIs') public String scope;
        
        // SMS Message Inputs
        @InvocableVariable(required=true label='_SFMC SMS Message Api Key' description='Api Key for the SFMC Outbound Message') public String messageApiKey;
        @InvocableVariable(required=true label='_SFMC SMS Message Keyword' description='Keyword specified for the SFMC Outbound Message') public String keyword;
		@InvocableVariable(required=true label='Mobile Number' description='Mobile Number to send the SMS to') public String mobileNumber;
        @InvocableVariable(required=true label='Use Custom Message' description='Over-rides the message that is specified in the SFMC template with a custom message specified in the Flow') public Boolean useCustomMsg;
        @InvocableVariable(label='Custom Message' description='Text for the custom message (probably comes from the Platform Event)') public String message;
        @InvocableVariable(label='Content URL (US-Only)' description='Optional link to send in SMS') public String contentUrl;
        
        // API Layer Number Reformatting Inputs
        @InvocableVariable(label='Format Number' description='Option to attempt to reformat the mobile number to the correct format') public Boolean formatNumber;
        @InvocableVariable(label='Format Number Country Code' description='Country Code to use when reformatting number, use 2-char ISO 3166 code') public String countryCode;
        @InvocableVariable(label='Format Number ApiLayer API Key') public String apiLayerApiKey;

    }

}