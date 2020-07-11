public without sharing class COT_PublicSiteUserController
{

    //public_site_user sharing rule
    public String email {get;set;}
    public String password {get;set;}

    public Boolean isForgetPassword {get;set;}

    public Boolean isResetPassword {get;set;}

    public String newPassword1 {get;set;}
    public String newPassword2 {get;set;}

    public COT_PublicSiteUserController()
    {
        isForgetPassword = false;
        isResetPassword = false;
    }

    public void Init()
    {

    }

    public PageReference Login()
    {
        PageReference page;
        ApexPages.Message msg;
        Boolean errFound = false;
        List<Public_Site_User__c> users;
        Public_Site_User__c u;
        String hashedPassword;

        email = email.trim().toLowerCase();
        if (String.isBlank(email) || String.isBlank(password))
        {
            errFound = true;
            msg = new ApexPages.Message(ApexPages.Severity.Error, 'Please check your username and password. If you still can\'t log in, contact your Salesforce administrator.');
        }

        if (!errFound)
        {
            users = [SELECT Id,First_Name__c,Last_Name__c,Password__c,Reset__c,
                Login_Expiry_Date_Time__c FROM Public_Site_User__c WHERE Email__c = :email AND Active__c = true LIMIT 1];

            if (users.isEmpty())
            {
                errFound = true;
                msg = new ApexPages.Message(ApexPages.Severity.Error, 'Please check your username and password. If you still can\'t log in, contact your Salesforce administrator.');
            }
        }

        if (!errFound)
        {
            u = users[0];
            hashedPassword = HashCode(password);
            System.debug('password:' + password);
            System.debug('u.password:' + u.Password__c);
            System.debug('u.hashedPassword:' + hashedPassword);
            if (hashedPassword != u.Password__c)
            {
                errFound = true;
                if (isResetPassword)
                {
                    msg = new ApexPages.Message(ApexPages.Severity.Error, 'Old password is incorrect.');
                }
                else
                {
                    msg = new ApexPages.Message(ApexPages.Severity.Error, 'Please check your username and password. If you still can\'t log in, contact your Salesforce administrator.');
                }
            }
        }

        if (!errFound)
        {

            if (isResetPassword)
            {
                if (!newpassword1.equals(newPassword2))
                {
                    errFound = true;
                    msg = new ApexPages.Message(ApexPages.Severity.Error, 'New password mismatch found, password is case sensitive, please reenter your new password.');
                }

                if (!errFound && (!checkPasswordComplicity(newPassword1)))
                {
                    errFound = true;
                    msg = new ApexPages.Message(ApexPages.Severity.Error, 'New password must be between 6 and 14 characters;A combination of uppercase and lowercase letter and number are required.');
                }

                if (!errFound)
                {
                    string newpwd = HashCode(newpassword1);
                    u.Reset__c = false;
                    u.password__c = newpwd;
                    update u;

                    page = redirectToContactPage(u);
                }

            }
            else
            {
                if (u.Reset__c)
                {
                    isResetPassword = true;
                }
                else
                {
                    page = redirectToContactPage(u);
                }
            }
        }

        if (msg != null)
        {
            ApexPages.addMessage(msg) ; //new ApexPages.Message(ApexPages.Severity.Error, 'Please check your username and password. If you still can\'t log in, contact your Salesforce administrator.'));
        }
        return page;
    }

    private PageReference redirectToContactPage(Public_Site_User__c u)
    {
        u = [Select Id,Login_Expiry_Date_Time__c FROM Public_Site_User__c WHERE Id = :u.Id];

        u.Login_Expiry_Date_Time__c = DateTime.Now().addHours(8);
        update u;

        u = [Select Id,Session__c FROM Public_Site_User__c WHERE Id = :u.Id];

        PageReference contactPage = Page.Contacts;
        contactPage.getParameters().put('sid',u.Session__c);
        contactPage.getParameters().put('pid',u.Id);
        contactPage.setRedirect(true);
        return contactPage;
    }

    public void forgetPassword()
    {
        isForgetPassword = true;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'To reset your password, enter your email.'));
    }

    public void changePassword()
    {
        isResetPassword = true;
    }

    public void sendResetPassword()
    {
        email = email.trim();

        if (String.isBlank(email))
        {
            return;
        }

        List<Public_Site_User__c> u = [SELECT Id,First_Name__c,Last_Name__c,Password__c,Reset__c FROM Public_Site_User__c WHERE Email__c = :email AND Active__c = true LIMIT 1];
        if (!u.isEmpty())
        {
            if (u[0].Reset__c)
            {
                u[0].Reset__c = false;
                update u;
            }
            u[0].Reset__c = true;
            update u;
        }

        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please check your username and password. If you still can\'t log in, contact your Salesforce administrator.'));

        isForgetPassword = false;
    }

    public void Cancel()
    {
        isForgetPassword = false;
        isResetPassword = false;

        email = '';
        password = '';
    }

    public static void emailPasswordChange(List<Id> userIds)
    {
        if (userIds == null || userIds.isEmpty())
        {
            return;
        }

        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

        List<Public_Site_User__c> users = [SELECT Id,Password__c,Email__c FROM Public_Site_User__c WHERE Id in : userIds];
        OrgWideEmailAddress EDCemail = [SELECT id, Address FROM OrgWideEmailAddress WHERE Address='edc_toronto@toronto.ca'];

        string siteUrl = Site.getBaseUrl();

        if (String.isBlank(siteUrl))
        {
            Site site = [SELECT Id From Site WHERE Name ='Contact_Request' Limit 1];
            SiteDetail sitedetail = [select SecureURL from SiteDetail where durableid = :site.Id];
            siteUrl = sitedetail.SecureURL;
        }
        for (Public_Site_User__c u : users)
        {

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            mail.setOrgWideEmailAddressId(EDCemail.Id);
            mail.setToAddresses(new String[] {u.Email__c});
            mail.setReplyTo('no-reply@toronto.com');
            mail.setSubject('Password Changed');
            string body = 'Please be advised your password for the following site has been changed successfully.\r\n\r\n';
            body += 'Login Url:' + siteUrl + '/publicsiteuser' + '\r\n\r\n';
            body += 'If this is not expected, please contact EDC Salesforce support edc_toronto@toronto.ca';

            mail.setPlainTextBody(body);
            mails.add(mail);
        }

        Update users;

        Messaging.sendEmail(mails,false);


    }

    public static void resetPassword(List<Id> userIds)
    {

        if (userIds == null || userIds.isEmpty())
        {
            return;
        }

        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

        List<Public_Site_User__c> users = [SELECT Id,Password__c,Email__c FROM Public_Site_User__c WHERE Id in : userIds];
        OrgWideEmailAddress EDCemail = [SELECT id, Address FROM OrgWideEmailAddress WHERE Address='edc_toronto@toronto.ca'];

        string siteUrl = Site.getBaseUrl();

        if (String.isBlank(siteUrl))
        {
            Site site = [SELECT Id From Site WHERE Name ='Contact_Request' Limit 1];
            SiteDetail sitedetail = [select SecureURL from SiteDetail where durableid = :site.Id];
            siteUrl = sitedetail.SecureURL;
        }
        for (Public_Site_User__c u : users)
        {

            String tempPassword = GenerateRandomString(6);

            u.Password__c = HashCode(tempPassword);

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            mail.setOrgWideEmailAddressId(EDCemail.Id);
            mail.setToAddresses(new String[] {u.Email__c});
            mail.setReplyTo('no-reply@toronto.com');
            mail.setSubject('Temporary Password');
            string body = 'Your temporary password is ' + tempPassword + '\r\n\r\n';


            body += 'Login Url:' + siteUrl + '/publicsiteuser';

            mail.setPlainTextBody(body);
            mails.add(mail);
        }

        Update users;

        Messaging.sendEmail(mails,false);


    }

    public static void resetToken(List<Id> userIds)
    {

        if (userIds == null || userIds.isEmpty())
        {
            return;
        }

        List<Public_Site_User__c> users = [SELECT Id,Session__c FROM Public_Site_User__c WHERE Id in : userIds];

        for (Public_Site_User__c u : users)
        {
            u.Session__c = GenerateRandomString(64);
        }

        Update users;

    }

    public static String HashCode(String s)
    {
        return String.valueOf( 31 * s.hashcode());
    }

    Public static String GenerateRandomString(Integer length)
    {
        if (length > 64)
        {
            length = 64;
        }
        Blob blobKey = crypto.generateAesKey(256);
        String key = EncodingUtil.convertToHex(blobKey);
        return key.substring(0,length);
    }


    private static Boolean checkPasswordComplicity(String s)
    {
        Pattern MyPattern = Pattern.compile('((?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[~!@#$%^&*()_+-={}]).{6,20})');

        // Then instantiate a new Matcher object "MyMatcher"
        Matcher MyMatcher = MyPattern.matcher(s);

        return MyMatcher.matches();
    }

}