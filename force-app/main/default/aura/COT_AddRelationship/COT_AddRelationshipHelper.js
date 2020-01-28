({
    createRecord : function (cmp) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Related_Interaction_Contact__c",
            "defaultFieldValues": {
                "Contact__c": cmp.get("v.recordId")
            }
        });
        createRecordEvent.fire();

        cmp.set("v.displayPageLayout",false);
    },
})