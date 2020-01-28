({
    createRecord : function (cmp) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Campaign",
            "recordTypeId": cmp.get("v.selectedRecordTypeId"), //"0121N0000012kqJ",  //Investment Activity
            "defaultFieldValues": {
                "Account__c": cmp.get("v.recordId")
            }
        });
        createRecordEvent.fire();

        cmp.set("v.displayPageLayout",true);
    },
})