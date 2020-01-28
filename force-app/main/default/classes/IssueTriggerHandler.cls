public class IssueTriggerHandler {
    public void OnBeforeInsert(List<Issue__c> newIssue) {
        system.debug('Issue Trigger On Before Insert');
        IssueTriggerActions.validateAccountRelationOnIssue(newIssue);
    }
    public void OnAfterInsert(List<Issue__c> newIssue){
        system.debug('IssueTrigger On After Insert');
        IssueTriggerActions.updateAssignedToOnIssue(newIssue);
    }
    public void OnBeforeUpdate(List<Issue__c> newIssue, List<Issue__c> oldIssue, Map<ID, Issue__c> newIssueMap , Map<ID, Issue__c> oldIssueMap) {
        system.debug('IssueTrigger On Before Update ');
        IssueTriggerActions.validateAccountRelationOnIssue(newIssue);
    }
}