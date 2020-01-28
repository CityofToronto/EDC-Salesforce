({
    createRecord : function (cmp) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Interaction__c",
            "recordTypeId": cmp.get("v.selectedRecordTypeId"),
            "defaultFieldValues": {
                "Contact__c": cmp.get("v.recordId"),
                "Account__c": cmp.get("v.loadedRecord.AccountId")
            }
        });
        createRecordEvent.fire();

        cmp.set("v.displayPageLayout",true);
    },
})