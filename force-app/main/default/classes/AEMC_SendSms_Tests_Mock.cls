/*
 * =======================
 * AEMC_SendSms_Tests_Mock
 * =======================
 * 
 * This class provides a simple mock web service to support the AEMC_SendSms_Tests unit test class.
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
global class AEMC_SendSms_Tests_Mock implements HttpCalloutMock {
    
    global HttpResponse respond(HttpRequest req) {
        
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setStatusCode(200);
        if(req.getEndpoint().endsWith('/v2/token')) {
            AEMC_SendSmsQueueable.AuthResponse ar = new AEMC_SendSmsQueueable.AuthResponse();
            ar.access_token = 'TESTACCESSTOKEN';
            ar.rest_instance_url = 'https://TESTPREFIX.rest.marketingcloudapis.com/';
            res.setBody(JSON.serialize(ar));            
        } else if(req.getEndpoint().startsWith('https://api.apilayer.com')) {
			AEMC_SendSmsQueueable.FormattedNumber fn = new AEMC_SendSmsQueueable.FormattedNumber();
            fn.valid = true;
        	fn.international_format = '+61411123123';
            fn.local_format = '0411123123';
            fn.line_type = 'mobile';
            res.setBody(JSON.serialize(fn));
        } else if(req.getEndpoint().endsWith('/send')) {
	        res.setStatus('OK');
        	res.setStatusCode(200);
            res.setBody('{ "tokenId" : "1234567890" }');
        }
        return res;
        
    }

}