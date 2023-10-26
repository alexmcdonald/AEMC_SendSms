/*
 * ==================
 * AEMC_SendSms_Tests
 * ==================
 * 
 * This class runs a very basic set of unit tests to provide required code coverage of the AEMC classes.
 * 
 * The tests are the bare minimum, additional tests for different paths and exception conditions should be built as part of any
 * implementation that references this component.
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

@isTest
public class AEMC_SendSms_Tests {
    
    @TestSetup static void setup() {
        
        Account a = new Account(Name='Test Account');
        insert(a);
        
        Contact c = new Contact(AccountId=a.Id, FirstName='Test', LastName='Test', Phone='61411123123', Email='test@example.com');
        insert(c);
        
    }
    
    @isTest static void testSmsPEAction() {
        
        AEMC_SendSms_Tests_Mock mock = new AEMC_SendSms_Tests_Mock();
        Test.setMock(HttpCalloutMock.class, mock);

        AEMC_SendSmsPEAction.InputData input = new AEMC_SendSmsPEAction.InputData();
        input.mobileNumber = '0411123123';
        input.messageContent = 'TEST MESSAGE';
        input.reformatNumber = '1';
        input.countryCode = 'AU';
      
        Test.startTest();
        AEMC_SendSmsPEAction.execute(new List<AEMC_SendSmsPEAction.InputData>{input});
        Test.stopTest();
        
    }
    
    @isTest static void testSmsFlowAction() {
        
        // Should be redundant, as the PE Action test should kick off the flow that calls this.
        // But, just in case the flow is deactivated or whatever, this tests the action manually.
        
        AEMC_SendSms_Tests_Mock mock = new AEMC_SendSms_Tests_Mock();
        Test.setMock(HttpCalloutMock.class, mock);
        
        AEMC_SendSmsFlowAction.InputData input = new AEMC_SendSmsFlowAction.InputData();
        input.apiPrefix = 'TESTPREFIX';
        input.clientId = 'TESTCLIENTID';
        input.clientSecret = 'TESTCLIENTSECRET';
        input.mID = 'TESTMID';
        input.scope = 'TESTSCOPE';
        input.messageApiKey = 'TESTKEY';
        input.keyword = 'TESTING';
        input.mobileNumber = '0411123123';
        input.useCustomMsg = TRUE;
        input.message = 'TEST MESSAGE';
        input.contentUrl = 'TEST';
        input.formatNumber = TRUE;
        input.countryCode = 'AU';
        input.apiLayerApiKey = 'TESTAPILAYERKEY';
        
        Test.startTest();
        List<String> result = AEMC_SendSmsFlowAction.execute(new List<AEMC_SendSmsFlowAction.InputData>{input});
        System.debug('Test SMS Flow Action Result: '+result);
        System.assert(result[0].startsWith('7'));
        Test.stopTest();
    }
    
}
