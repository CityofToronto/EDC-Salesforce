trigger PublicSiteUserTrigger on Public_Site_User__c (BEFORE Insert,AFTER Insert,BEFORE Update, AFTER Update) {

    if (Trigger.isAfter && Trigger.isUpdate) {
        List<Id> updateUsers = new List<Id>();
        List<Id> updateUsersToken = new List<Id>();
        List<Id> updatePassword = new List<Id>();
        Public_Site_User__c newUser;
        Public_Site_User__c oldUser;
        for (Public_Site_User__c u: trigger.new)
        {
            newUser = Trigger.newMap.get(u.Id);
            oldUser = Trigger.oldMap.get(u.Id);

            if (!newUser.reset__C && (newUser.password__c != oldUser.password__c))
            {
                updatePassword.add(u.Id);
            }
            if (newUser.Reset__c && (!oldUser.Reset__c)){
                updateUsers.add(u.Id);
            }

            if (newUser.Login_Expiry_Date_Time__c != oldUser.Login_Expiry_Date_Time__c){
                updateUsersToken.add(u.Id);
            }
        }

        if (updatePassword.size() > 0){
            COT_PublicSiteUserController.emailPasswordChange(updatePassword);
        }

        if (updateUsers.size() > 0){
            COT_PublicSiteUserController.resetPassword(updateUsers);
        }

        if (updateUsersToken.size() > 0){
            COT_PublicSiteUserController.resetToken(updateUsersToken);
        }
    }
    else if (Trigger.isAfter && Trigger.isInsert)
    {
        List<Id> updateUsers = new List<Id>();
        for (Public_Site_User__c u: trigger.new)
        {
            updateUsers.add(u.Id);
        }
        system.debug('updateUdrs after insert:' + updateUsers);
        COT_PublicSiteUserController.resetPassword(updateUsers);
    }
    else if (Trigger.isBefore)
    {
        for (Public_Site_User__c u : trigger.new){
            u.email__c = u.email__c.toLowerCase();
            if (trigger.isInsert)
            {
                u.reset__c = true;
            }
        }
    }

}