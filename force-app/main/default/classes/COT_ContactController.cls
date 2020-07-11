public with sharing class COT_ContactController
{
    //permission set to access Contact FLS  - City of Toronto Site Public User Permission Set
    //Account Sharing rule

    public List<Contact> contactList
    {
        get
        {
            if(contactRecordSet != null)
            {
                return (List<Contact>)contactRecordSet.getRecords();
            }
            else
            {
                return null ;
            }
        }
        set;
    }

    public Boolean isContactDisplayed {get;set;}

    public Id recordId {get;set;}

    public String selectedView {get;set;}

    public List<SelectOption> availableViews {get;set;}

    public string selectedSearchChar {get;set;}

    public Integer rowPerPage {get;set;}

    public String searchString {get;set;}

    private ApexPages.StandardSetController contactRecordSet{get; set;}

    private String sortExp = 'name';

    public String UserName {get;set;}

    public Boolean isSearch {get;set;}

    private DateTime ExpiryDateTime;

    public String sortExpression
    {
        get
        {
            return sortExp;
        }
        set
        {
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp)
            {
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            }
            else
            {
                sortDirection = 'ASC';
            }
            sortExp = value;
        }
    }

    public String sortDirection
    {
        get
        {
            //if no column is selected
            if (sortExpression == null || sortExpression == '')
                return 'ASC';
            else
                return sortDirection;
        }
        Set
        {
            sortDirection = value;
        }
    }

    public COT_ContactController()
    {
        selectedSearchChar = 'All';

        availableViews = New List<SelectOption>();
        availableViews.add(new SelectOption('1', 'All Contacts'));
        availableViews.add(new SelectOption('2', 'Birthday This Month'));
        availableViews.add(new SelectOption('3', 'Contacts - Added Today'));
        availableViews.add(new SelectOption('4', 'Contacts - Modified Today'));
        availableViews.add(new SelectOption('5', 'ET Channel Partner List'));
        availableViews.add(new SelectOption('6', 'ET - Event Attendees'));
        selectedView = '1';

        isContactDisplayed = false;

        rowPerPage = 50;

        sortExpression = 'LastName';

        isSearch = false;

        queryContactList();

    }


    public Pagereference Init()
    {
        string pid = ApexPages.currentPage().getParameters().get('pid');
        string sid = ApexPages.currentPage().getParameters().get('sid');

         if (String.isBlank(pid))
        {
            Cookie pidcookie = ApexPages.currentPage().getCookies().get('pid');
            if (pidcookie !=null)
            {
                pid = pidcookie.getValue();
            }
        }

        if (String.isBlank(sid))
        {
            Cookie sidcookie = ApexPages.currentPage().getCookies().get('sid');
            if (sidcookie !=null)
            {
                sid = sidcookie.getValue();
            }
        }

        Boolean redirect = false;

        if (String.isBlank(pid) || String.isBlank(sid))
        {
            redirect = true;
        }
        else
        {
            List<Public_Site_User__c> users = [SELECT Login_Expiry_Date_Time__c,First_Name__c,Last_Name__c FROM Public_Site_User__c WHERE Id = :pid and Session__c = :sid];

            if (users.isEmpty()){
                redirect = true;
            }
            else
            {
                Public_Site_User__c u = users[0];

                UserName = u.First_Name__c + ' ' + u.Last_Name__c;

                if (u.Login_Expiry_Date_Time__c == null)
                {
                    ExpiryDateTime = Datetime.now().addhours(8);
                }
                else
                {
                    ExpiryDateTime = u.Login_Expiry_Date_Time__c;
                }

                if (u.Login_Expiry_Date_Time__c <  Datetime.now())
                {
                    redirect = true;
                }
                else
                {
                    List<Cookie> cookies = new List<Cookie>();
                    Cookie pidcookie = ApexPages.currentPage().getCookies().get('pid');
                    pidcookie = new Cookie('pid',pid,null,-1,false);
                    Cookie sidcookie = ApexPages.currentPage().getCookies().get('sid');
                    sidcookie = new Cookie('sid',sid,null,-1,false);
                    cookies.add(pidcookie);
                    cookies.add(sidcookie);
                    // Set the new cookie for the page
                    ApexPages.currentPage().setCookies(cookies);

                    system.debug('cookies:' + cookies);
                }
            }
        }

        if (redirect)
        {
            PageReference contactPage = Page.PublicSiteUser;
            contactPage.setRedirect(true);
            return contactPage;
        }



        return null;
    }

    public void queryContactsByFirstLetter()
    {
        if (!isSearch)
        {
            queryContactList();
        }
    }


    public void viewChanged()
    {
        selectedSearchChar = 'All';
        queryContactList();

    }

    public void queryContactList()
    {

        if (ExpiryDateTime < Datetime.now())
        {
            Logout();
            return;
        }
        this.isContactDisplayed = false;
        isSearch = false;
        this.searchString = '';

        /*
        String queryString = 'SELECT Id,firstName,lastName,account.Name,Contact_Type__c,Title,Contact_Type_Order__c,Department,' +
            'AssistantName,Secondary_Contact__c, BIA_Member_Company_Name__c,OtherStreet,MailingStreet,' +
            'OtherCity,MailingCity,OtherState,MailingState,OtherCountry,MailingCountry,OtherPostalCode,MailingPostalCode,' +
            'Phone,Email,MobilePhone,Other_Email__c,HomePhone,AssistantPhone,OtherPhone,Fax,What_sapp__c,Skype__c,Wechat__c,Viber__c,' +
            'ET_Newsletter__c,Add_to_BIA_Newsletter__c,BRE_Newsletter__c,Add_to_SDO_Newsletter__c,Add_to_SUH_Newsletter__c,' +
            'MC4SF__MC_Subscriber__c,HasOptedOutOfEmail,Createdby.Name,CreatedDate,LastModifiedby.Name,LastModifiedDate,Contact_Integration_Source__c' +
            ' FROM Contact';
        */
        String queryString = 'SELECT Id,name,firstName,lastName,account.Name,account.isPersonAccount,' +
            'Phone,Email,MobilePhone,HomePhone,HasOptedOutOfEmail,Createdby.Name,CreatedDate,LastModifiedby.Name,LastModifiedDate' +
            ' FROM Contact';

        if (sortExpression != 'HasOptedOutOfEmail')
        {

            if (sortExpression == 'AccountName')
            {
                sortExpression = 'Account.Name';
            }
            if (selectedSearchChar == 'Other')
            {
                queryString += ' WHERE (NOT ' + sortExpression + ' Like \'a%\') AND (NOT ' + sortExpression + ' Like \'b%\') AND (NOT ' + sortExpression + ' Like \'c%\') AND (NOT ' + sortExpression + ' Like \'d%\')' +
                ' AND (NOT ' + sortExpression + ' Like \'e%\') AND (NOT ' + sortExpression + ' Like \'f%\') AND (NOT ' + sortExpression + ' Like \'g%\') AND (NOT ' + sortExpression + ' Like \'h%\')' +
                ' AND (NOT ' + sortExpression + ' Like \'i%\') AND (NOT ' + sortExpression + ' Like \'j%\') AND (NOT ' + sortExpression + ' Like \'k%\') AND (NOT ' + sortExpression + ' Like \'l%\')' +
                ' AND (NOT ' + sortExpression + ' Like \'m%\') AND (NOT ' + sortExpression + ' Like \'n%\') AND (NOT ' + sortExpression + ' Like \'o%\') AND (NOT ' + sortExpression + ' Like \'p%\')' +
                ' AND (NOT ' + sortExpression + ' Like \'q%\') AND (NOT ' + sortExpression + ' Like \'r%\') AND (NOT ' + sortExpression + ' Like \'s%\') AND (NOT ' + sortExpression + ' Like \'t%\')' +
                ' AND (NOT ' + sortExpression + ' Like \'u%\') AND (NOT ' + sortExpression + ' Like \'v%\') AND (NOT ' + sortExpression + ' Like \'w%\') AND (NOT ' + sortExpression + ' Like \'x%\')' +
                ' AND (NOT ' + sortExpression + ' Like \'y%\') AND (NOT ' + sortExpression + ' Like \'z%\')' ;
            }
            else if (selectedSearchChar != 'All')
            {
                queryString += ' WHERE ' + sortExpression + ' Like \'' + selectedSearchChar + '%\'';

            }

        }
        switch on selectedView {
            when '2' {
                if (selectedSearchChar == 'Other' || selectedSearchChar != 'All')
                {
                    queryString += ' AND Birthdate = THIS_MONTH';
                }
                else {
                    queryString += ' WHERE Birthdate = THIS_MONTH';
                }
            }
            when '3' {
                if (selectedSearchChar == 'Other' || selectedSearchChar != 'All')
                {
                    queryString += ' AND CREATEDDATE = TODAY';
                }
                else {
                    queryString += ' WHERE CREATEDDATE = TODAY';
                }
            }
            when '4' {
                if (selectedSearchChar == 'Other' || selectedSearchChar != 'All')
                {
                    queryString += ' AND LastModifiedDate = TODAY';
                }
                else {
                    queryString += ' WHERE LastModifiedDate = TODAY';
                }
            }
            when else {

            }
        }

        switch on  sortExpression
        {
            when 'Email'
            {
                queryString += ' ORDER BY Email ' + sortDirection;
            }
            when 'Phone'
            {
                queryString += ' ORDER BY Phone ' + sortDirection;
            }
            when 'MobilePhone'
            {
                queryString += ' ORDER BY MobilePhone ' + sortDirection;
            }
            when 'HomePhone'
            {
                queryString += ' ORDER BY HomePhone ' + sortDirection;
            }
            when 'HasOptedOutOfEmail'
            {
                queryString += ' ORDER BY HasOptedOutOfEmail ' + sortDirection;
            }
            when 'Account.Name'
            {
                queryString += ' ORDER BY Account.Name ' + sortDirection;
            }
            when 'FirstName'
            {
                queryString += ' ORDER BY FirstName ' + sortDirection;
            }
            when else
            {
                queryString += ' ORDER BY LastName ' + sortDirection;
            }
        }

        if (sortDirection == 'ASC')
        {
            queryString += ' NULLS First';
        }
        else
        {
            queryString += ' NULLS LAST';
        }

        queryString += ' LIMIT 9500';

        contactRecordSet = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));

        contactRecordSet.setPageSize(rowPerPage);

        if (contactRecordSet.getResultSize() == 0)
        {
            pageNumber = 0;
            totalPageNumbers =  0;
        }
        else
        {
            Integer count = contactRecordSet.getResultSize()/rowPerPage;
            if (Math.mod( contactRecordSet.getResultSize(), rowPerPage) > 0)
            {
                count ++;
            }
            pageNumber = 1;

            totalPageNumbers =  count;
        }

        hasPrevious = false;
        hasNext = totalPageNumbers>1?true:false;
        totalRecords = contactRecordSet.getResultSize();
    }


    public Pagereference viewContactDetail()
    {
        isContactDisplayed = true;
        return null;
    }

    public PageReference returnToList()
    {
        if (isContactDisplayed)
        {
            isContactDisplayed = false;
            return null;
        }
        else if (isSearch)
        {
            isSearch = false;
            this.searchString = '';
            this.queryContactList();
        }
        return null;
    }

    @RemoteAction
    public Static List<String> getAutoCompleteContact(String searchString)
    {
        List<String> result = new List<String>();

        searchString = searchString.trim();

        If (searchString.length() >=2)
        {
            String queryString='FIND\'' + searchString + '*\'IN ALL FIELDS RETURNING Contact (Id,name,firstName,' +
                'lastName,account.Name,Phone,Email,MobilePhone,HomePhone,HasOptedOutOfEmail,Createdby.Name,' +
                'CreatedDate,LastModifiedby.Name,LastModifiedDate ORDER BY LastName LIMIT 20)';

            List<List<SObject>> searchList = search.query(queryString);

            List<Contact> contacts = ((List<Contact>)searchList[0]);

            for (Contact c : contacts)
            {
                String name = '';
                if (String.isNotEmpty(c.firstName))
                {
                    name = c.firstName + ' ';
                }
                name += c.lastName;
                result.add(name);
            }
        }

        return result;
    }

    public Pagereference search()
    {
        searchString = searchString.trim();

        if (String.isBlank(searchString))
        {
            this.queryContactList();
            return null;
        }

        String queryString='FIND\'' + searchString + '*\'IN ALL FIELDS RETURNING Contact (Id,name,firstName,' +
                'lastName,account.Name,Phone,Email,MobilePhone,HomePhone,HasOptedOutOfEmail,Createdby.Name,' +
                'CreatedDate,LastModifiedby.Name,LastModifiedDate ORDER BY LastName LIMIT 2000)';

        List<List<SObject>> searchList = search.query(queryString);

        List<Contact> contacts = ((List<Contact>)searchList[0]);

        contactRecordSet = new ApexPages.StandardSetController(contacts);
        contactRecordSet.setPageSize(rowPerPage);
        isSearch = true;
        isContactDisplayed = false;
        sortExpression = 'LastName';
        sortDirection = 'ASC';

        if (contactRecordSet.getResultSize() == 0)
        {
            pageNumber = 0;
            totalPageNumbers =  0;
        }
        else
        {
            Integer count = contactRecordSet.getResultSize()/rowPerPage;
            if (Math.mod( contactRecordSet.getResultSize(), rowPerPage) > 0)
            {
                count ++;
            }

            pageNumber = 1;
            totalPageNumbers =  count;
        }
        hasPrevious = false;
        hasNext = totalPageNumbers>1?true:false;
        totalRecords = contactRecordSet.getResultSize();
        return null;

    }

    public Pagereference Logout()
    {
        List<Cookie> cookies = new List<Cookie>();
        Cookie pidcookie = ApexPages.currentPage().getCookies().get('pid');
        pidcookie = new Cookie('pid','',null,-1,false);
        Cookie sidcookie = ApexPages.currentPage().getCookies().get('sid');
        sidcookie = new Cookie('sid','',null,-1,false);
        cookies.add(pidcookie);
        cookies.add(sidcookie);
        // Set the new cookie for the page
        ApexPages.currentPage().setCookies(cookies);

        PageReference contactPage = Page.PublicSiteUser;
        contactPage.setRedirect(true);
        return contactPage;
    }

    //Pagination
    public Boolean hasNext { get; set; }
    public Boolean hasPrevious { get;set;}

    public Integer pageNumber{get;set;}

    public Integer totalRecords{get;set;}

    public Integer totalPageNumbers {get;set;}

    public Pagereference previous()
    {
        contactRecordSet.previous();
        pageNumber--;
        hasNext =  pageNumber < totalPageNumbers?true:false;
        hasPrevious = pageNumber > 1?true:false;
        return null;
    }
    public Pagereference next()
    {
        contactRecordSet.next();
        pageNumber++;
        hasNext =  pageNumber < totalPageNumbers?true:false;
        hasPrevious = pageNumber > 1?true:false;
        return null;
    }

}