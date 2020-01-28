({
    ConvertBusinessAccount : function(cmp) {
        var action = cmp.get("c.convertPersonToBusinessAccount");
        action.setParams({"accountId": cmp.get("v.recordId")});
        // Configure response handler
        action.setCallback(this, function(response) {
            var state = response.getState();
            var resultsToast = $A.get("e.force:showToast");
            if(state === "SUCCESS") {
                resultsToast.setParams({
                    "title": "Account Converted",
                    "message": "The Person Account Has Been Converted to Business Account Successfully.",
                    "type": "success"
                });
                // Update the UI: close panel, show toast, refresh account page
                
            } 
            else 
            {
                resultsToast.setParams({
                    "title": "Account Converted",
                    "message": "Failed to Convert Person Account Business Account.",
                    "type": "error"
                });
            }
            $A.get("e.force:closeQuickAction").fire();
            resultsToast.fire();
            $A.get("e.force:refreshView").fire();

        });
        $A.enqueueAction(action);

    },
})