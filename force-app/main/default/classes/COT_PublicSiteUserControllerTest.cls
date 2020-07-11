@isTest
public with sharing class COT_PublicSiteUserControllerTest {


    @TestSetup
    static void Setup(){
        COT_ContactControllerTest.Setup();
    }

    @IsTest
    static void testLogin(){

        COT_PublicSiteUserController controller = new COT_PublicSiteUserController();
        controller.Init();

        controller.email = 'Test1@toronto.ca';
        controller.Login();

        ApexPages.Message[] messages = ApexPages.getMessages();

        System.assert(messages.size() ==  1);
        System.assert( messages[0].getDetail().startsWith('Please check your username and password.'));

        controller.password = 'xxxxx';
        controller.Login();

        messages = ApexPages.getMessages();

        System.assert(messages.size() ==  1);
        System.assert( messages[0].getDetail().startsWith('Please check your username and password.'));



        controller.email = 'Test@toronto.ca';
        controller.password = 'Password123~!@x';
        controller.Login();
        messages = ApexPages.getMessages();

        System.assert(messages.size() ==  1);
        System.assert( messages[0].getDetail().startsWith('Please check your username and password.'));


        Public_Site_User__c user = [Select Id, reset__c,Password__c,Session__c from Public_Site_User__c Limit 1];
        user.Password__c = COT_PublicSiteUserController.HashCode('Password123~!@');
        user.reset__c = false;
        update user;

        controller.email = 'test@toronto.ca';
        controller.password = 'Password123~!@';

        string url = controller.Login().getUrl();
        user = [Select Id, reset__c,Password__c,Session__c from Public_Site_User__c Limit 1];

        System.assertEquals('/apex/contacts?pid=' + user.Id + '&sid=' + user.Session__c,url);

    }

    @IsTest
    static void testLoginResetPassword(){

        COT_PublicSiteUserController controller = new COT_PublicSiteUserController();

        ApexPages.Message[] messages = ApexPages.getMessages();

        controller.email = 'test@toronto.ca';
        controller.password = 'Password123~!@';
        Public_Site_User__c user = [Select Id, reset__c,Password__c,Session__c from Public_Site_User__c Limit 1];

        user.reset__c = true;
        update user;

        user = [Select Id, reset__c,Password__c,Session__c from Public_Site_User__c Limit 1];
        user.Password__c = COT_PublicSiteUserController.HashCode('Password123~!@');
        update user;

        controller.Login();

        System.assert(controller.isResetPassword);

        controller.password = 'Password123~!@x';
        controller.login();
        messages = ApexPages.getMessages();

        System.assert(messages.size() ==  1);
        System.assert( messages[0].getDetail().startsWith('Old password is incorrect.'));

        Test.clearApexPageMessages();

        controller.password = 'Password123~!@';
        controller.newpassword1 = '123';
        controller.newpassword2 = '123';
        controller.login();

        messages = ApexPages.getMessages();
        System.debug('messages:' + messages);
        System.assert(messages.size() ==  1);
        System.assert( messages[0].getDetail().startsWith('New password must be between 6 and 14 char'));

        Test.clearApexPageMessages();

        controller.newpassword1 = 'Password123~!@x';
        controller.newpassword2 = 'Password123~!@x1';
        controller.login();

        messages = ApexPages.getMessages();

        System.assert(messages.size() ==  1);
        System.assert( messages[0].getDetail().startsWith('New password mismatch found'));


        controller.newpassword2 = 'Password123~!@x';
        string url = controller.Login().getUrl();
        user = [Select Id, reset__c,Password__c,Session__c from Public_Site_User__c Limit 1];

        System.assertEquals('/apex/contacts?pid=' + user.Id + '&sid=' + user.Session__c,url);

    }

    @IsTest
    static void testForgotPassword(){

        COT_PublicSiteUserController controller = new COT_PublicSiteUserController();
        controller.forgetPassword();

        ApexPages.Message[] messages = ApexPages.getMessages();
        System.assert(messages.size() ==  1);
        System.assert( messages[0].getDetail().startsWith('To reset your password'));

    }

    @IsTest
    static void testChangePassword(){

        COT_PublicSiteUserController controller = new COT_PublicSiteUserController();
        controller.changePassword();

        System.assert(controller.isResetPassword);

    }

    @IsTest
    static void testSendResetPassword(){

        COT_PublicSiteUserController controller = new COT_PublicSiteUserController();
        controller.email = 'test@toronto.ca';
        controller.sendResetPassword();

        Public_Site_User__c u = [SELECT Id,First_Name__c,Last_Name__c,Password__c,Reset__c FROM Public_Site_User__c WHERE Email__c = :controller.email AND Active__c = true LIMIT 1];

        System.assert(u.Reset__c);
        ApexPages.Message[] messages = ApexPages.getMessages();
        System.assert(messages.size() ==  1);
        System.assert( messages[0].getDetail().startsWith('Please check your username and password'));


    }

    @IsTest
    static void testCancel(){

        COT_PublicSiteUserController controller = new COT_PublicSiteUserController();
        controller.email = 'test@toronto.ca';
        controller.cancel();
        System.assert(controller.email== '');
     }

}