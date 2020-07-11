@isTest
public with sharing class COT_ContactControllerTest {
    @TestSetup
    public static void Setup(){

        Public_Site_User__c user = new Public_Site_User__c();
        user.Email__c = 'Test@toronto.ca';
        user.First_Name__c = 'FirstName';
        user.Last_Name__c = 'LastName';
        user.Password__c = COT_PublicSiteUserController.HashCode('Password123~!@');
        user.Reset__c = false;
        user.Login_Expiry_Date_Time__c = System.today().addDays(2);
        user.Session__c = COT_PublicSiteUserController.GenerateRandomString(64);
        user.Active__c = true;
        insert user;

        Account account = new Account();
        account.Name = 'Test Account';
        insert account;

        List<Contact> contacts = new List<Contact>();
        for (integer i = 0;i<205;i++)
        {
            Contact contact = new Contact();

            contact.AccountId = account.Id;
            contact.FirstName = 'FTestFirstName' + i;
            contact.LastName = 'LTestLastName' + i;
            contact.Phone = '416999' + String.valueOf(i).leftPad(4,'0');
            contact.Email = 'ABC' + String.valueOf(i) + '@toronto.ca';
            contact.MobilePhone = '416998' + String.valueOf(i).leftPad(4,'0');
            contact.HomePhone = '416997' + String.valueOf(i).leftPad(4,'0');
            contact.HasOptedOutOfEmail=false;
            contact.Birthdate = System.today().addYears(-30);

            contacts.add(contact);
        }
        insert contacts;

    }

    @IsTest
    static void testConstructor(){

        COT_ContactController controller = new COT_ContactController();
        List<Contact> contacts = controller.contactList;
        System.assert(controller.totalRecords==205);
        system.assert(contacts.size() == 50);
    }

    @IsTest
    static void testInit(){

        Public_Site_User__c user = [Select Id,Session__c FROM Public_Site_User__c Limit 1];
        Test.setCurrentPage(Page.Contacts);
        ApexPages.currentPage().getParameters().put('pid',user.Id);
        ApexPages.currentPage().getParameters().put('sid',user.Session__c);

        COT_ContactController controller = new COT_ContactController();

        System.assertEquals(null,controller.Init());


        ApexPages.currentPage().getParameters().put('pid','');
        ApexPages.currentPage().getParameters().put('sid','');
        System.assertEquals(null,controller.Init());

    }


    @IsTest
    static void testInitException(){

        Public_Site_User__c user = [Select Id,Session__c,Login_Expiry_Date_Time__c FROM Public_Site_User__c Limit 1];
        user.Login_Expiry_Date_Time__c = System.today().addDays(-1);
        update user;
        user = [Select Id,Session__c,Login_Expiry_Date_Time__c FROM Public_Site_User__c Limit 1];
        Test.setCurrentPage(Page.Contacts);
        ApexPages.currentPage().getParameters().put('pid',user.Id);
        ApexPages.currentPage().getParameters().put('sid',user.Session__c);
        COT_ContactController controller = new COT_ContactController();
        System.assertEquals('/apex/publicsiteuser',controller.Init().getUrl());


        ApexPages.currentPage().getParameters().put('pid',user.Id);
        ApexPages.currentPage().getParameters().put('sid','aaaaa');
        controller = new COT_ContactController();
        System.assertEquals('/apex/publicsiteuser',controller.Init().getUrl());

        ApexPages.currentPage().getParameters().put('pid','223344923');
        ApexPages.currentPage().getParameters().put('sid',user.Session__c);
        controller = new COT_ContactController();
        System.assertEquals('/apex/publicsiteuser',controller.Init().getUrl());

        ApexPages.currentPage().getParameters().put('pid','');
        ApexPages.currentPage().getParameters().put('sid',user.Session__c);
        controller = new COT_ContactController();
        System.assertEquals('/apex/publicsiteuser',controller.Init().getUrl());


        ApexPages.currentPage().getParameters().put('pid',user.Id);
        ApexPages.currentPage().getParameters().put('sid','');
        controller = new COT_ContactController();
        System.assertEquals('/apex/publicsiteuser',controller.Init().getUrl());

    }

    @IsTest
    static void testQueryContactsByFirstLetter(){

       COT_ContactController controller = new COT_ContactController();
       controller.isSearch = false;
       controller.QueryContactsByFirstLetter();
       System.assert(controller.totalRecords==205);

    }

    @IsTest
    static void testViewChanged(){

       COT_ContactController controller = new COT_ContactController();
       controller.viewChanged();
       System.assert(controller.totalRecords==205);

    }


    @IsTest
    static void testQueryContactList(){

       COT_ContactController controller = new COT_ContactController();
       controller.sortExpression = 'LastName';
       controller.selectedSearchChar = 'L';
       controller.selectedView = '1';
       controller.queryContactList();
       System.assertEquals(controller.totalRecords,205);

       controller.selectedSearchChar = 'All';
       controller.selectedView = '1';
       controller.queryContactList();
       System.assert(controller.totalRecords==205);

       controller.sortExpression = 'FirstName';
       controller.selectedSearchChar = 'F';
       controller.selectedView = '2';
       controller.queryContactList();
       System.assert(controller.totalRecords==205);

       controller.selectedSearchChar = 'All';
       controller.queryContactList();
       System.assert(controller.totalRecords==205);


       controller.sortExpression = 'Email';
       controller.selectedSearchChar = 'A';
       controller.selectedView = '3';
       controller.sortDirection = 'DESC';
       controller.queryContactList();
       System.assert(controller.totalRecords==205);
       controller.selectedSearchChar = 'All';
       controller.queryContactList();
       System.assert(controller.totalRecords==205);


       controller.sortExpression = 'Phone';
       controller.selectedSearchChar = '4';
       controller.selectedView = '4';
       controller.queryContactList();
       System.assert(controller.totalRecords==205);

       controller.selectedSearchChar = 'All';
       controller.queryContactList();
       System.assert(controller.totalRecords==205);

       controller.sortExpression = 'MobilePhone';
       controller.queryContactList();
       System.assert(controller.totalRecords==205);

       controller.sortExpression = 'HomePhone';
       controller.queryContactList();
       System.assert(controller.totalRecords==205);

       controller.selectedSearchChar = 'Other';
       controller.queryContactList();
       System.assert(controller.totalRecords==205);

       controller.sortExpression = 'AccountName';
       controller.selectedSearchChar = 'T';
       controller.queryContactList();
       System.assert(controller.totalRecords==205);


       controller.sortExpression = 'HasOptedOutOfEmail';
       controller.selectedSearchChar = 'A';
       controller.selectedView = '1';
       controller.sortDirection = '';
       controller.queryContactList();
       System.assert(controller.totalRecords==205);


       controller.sortExpression = 'AccountName';
       controller.selectedSearchChar = 'S';
       controller.queryContactList();
       System.assert(controller.totalRecords==0);

    }

    @IsTest
    static void testViewContactDetail(){

        COT_ContactController controller = new COT_ContactController();
        controller.viewContactDetail();
        System.assert(controller.isContactDisplayed);

    }

    @IsTest
    static void testTeturnToList(){

        COT_ContactController controller = new COT_ContactController();
        controller.isSearch = true;
        controller.returnToList();
        controller.viewContactDetail();
        System.assertEquals(null,controller.returnToList());

    }

    @IsTest
    static void testGetAutoCompleteContact(){

        Id [] fixedSearchResults= new Id[205];

        List<Contact> contacts = [Select Id from Contact];
        for (integer i =0;i<205;i++)
        {
            fixedSearchResults[i] = contacts[i].Id;
        }
        Test.setFixedSearchResults(fixedSearchResults);
        List<String> lst = COT_ContactController.getAutoCompleteContact('test');
        System.assert(lst.size() > 0);

    }

    @IsTest
    static void testSearch(){

        COT_ContactController controller = new COT_ContactController();
        controller.searchString = '';
        system.assertEquals(null,controller.search());


        controller.searchString = 'xxxxx';
        controller.search();
        system.assertEquals(0,controller.totalRecords);
        system.assertEquals(0,controller.totalPageNumbers);

        Id [] fixedSearchResults= new Id[205];

        List<Contact> contacts = [Select Id from Contact];
        for (integer i =0;i<205;i++)
        {
            fixedSearchResults[i] = contacts[i].Id;
        }
        Test.setFixedSearchResults(fixedSearchResults);

        controller.searchString = 'test';
        controller.search();
        system.assertEquals(205,controller.totalRecords);
        system.assertEquals(5,controller.totalPageNumbers);

    }

    @IsTest
    static void testLogout(){

        COT_ContactController controller = new COT_ContactController();
        System.assertEquals('/apex/publicsiteuser',controller.Logout().getUrl());
    }

    @IsTest
    static void testNavigation(){

        COT_ContactController controller = new COT_ContactController();
        Id [] fixedSearchResults= new Id[205];

        List<Contact> contacts = [Select Id from Contact];
        for (integer i =0;i<205;i++)
        {
            fixedSearchResults[i] = contacts[i].Id;
        }
        Test.setFixedSearchResults(fixedSearchResults);

        controller.searchString = 'test';
        controller.search();
        controller.next();
        System.assertEquals(2,controller.pageNumber);

        controller.previous();
        System.assertEquals(1,controller.pageNumber);

    }
}