({
    getRecordTypes : function(cmp) {
        var helper = this;

        var action = cmp.get("c.getRecordTypes");
        action.setParams({"apiName": cmp.get("v.objcetApiName"),
                        "recordTypeName": cmp.get("v.recordTypeName")});
        
        // Configure response handler
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                cmp.set("v.recordTypes",response.getReturnValue());

                if (cmp.get("v.recordTypes").length == 0)
                    cmp.getConcreteComponent().createRecordMethod();
                else if (cmp.get("v.recordTypes").length == 1)
                    cmp.set("v.selectedRecordTypeId",cmp.get("v.recordTypes")[0].Id);
                else if (cmp.get("v.recordTypes").length > 1)
                {
                    var v = cmp.get("v.recordTypes");
                    for (var c in v)
                    {
                        if (v[c].checked)
                        {
                            cmp.set("v.selectedRecordTypeId",v[c].Id);
                            break;
                        }
                    }
                }
                cmp.set("v.startLoadingData",true);
                
            } 
        });
        $A.enqueueAction(action);
    },

    getDefaultRecordType : function(cmp) {
        var helper = this;

        var action = cmp.get("c.getDefaultRecordType");
        action.setParams({"apiName": cmp.get("v.objcetApiName")});
        
        // Configure response handler
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                cmp.set("v.selectedRecordTypeId",response.getReturnValue());
            } 
        });
        $A.enqueueAction(action);
    },

})