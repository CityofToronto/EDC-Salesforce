({
    createRecord : function (cmp) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Financial_Incentive__c",
            "recordTypeId": cmp.get("v.selectedRecordTypeId"),//"0121N000001M6bQQAS",  //IMIT
            "defaultFieldValues": {
                "Account__c": cmp.get("v.loadedRecord.Account__c"),
                "Initiative__c": cmp.get("v.recordId")
            }
        });
        createRecordEvent.fire();

        cmp.set("v.displayPageLayout",true);
    },
})