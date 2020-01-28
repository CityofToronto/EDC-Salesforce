({
    createRecord : function (cmp) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Issue__c",
            "recordTypeId": cmp.get("v.selectedRecordTypeId"), //"0121N0000012kqJ",  //Investment Activity
            "defaultFieldValues": {
                "Contact__c": cmp.get("v.recordId"),
                "Account__c": cmp.get("v.loadedRecord.AccountId")
            }
        });
        createRecordEvent.fire();

        cmp.set("v.displayPageLayout",true);
    },
})