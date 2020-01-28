public class AccountTriggerHandler {
    public void OnBeforeInsert(List<Account> newAccount) {
        system.debug('Account Trigger On Before Insert');
        AccountTriggerActions.updateContinentOnAccount(newAccount,null);
        AccountTriggerActions.updateAutoAccCreationFlagOnAccount(newAccount,null);
        AccountTriggerActions.updateBIABoardSizeBeforeUpdate(newAccount,null);
    
    }
    /*public void OnAfterInsert(List<Account> newAccount)
    {
        system.debug('Account Trigger On After Insert');
    }
    public void OnAfterUpdate( List<Account> newAccount, List<Account> oldAccount, Map<ID, Account> newAccountMap , Map<ID, Account> oldAccountMap )
    {
        system.debug('Account Trigger On After Update ');
    }
    */
    public void OnBeforeUpdate(List<Account> newAccount, List<Account> oldAccount, Map<ID, Account> newAccountMap , Map<ID, Account> oldAccountMap) {
        system.debug('Account Trigger On Before Update ');
        AccountTriggerActions.updateContinentOnAccount(newAccount,oldAccountMap);
        AccountTriggerActions.updateAutoAccCreationFlagOnAccount(newAccount,oldAccountMap);
        AccountTriggerActions.updateBIABoardSizeBeforeUpdate(newAccount,oldAccountMap);
    
    }
}