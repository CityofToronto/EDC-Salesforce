({
    loadRecordType : function (component, event, helper) {
        helper.getRecordTypes(component);
    },


    close : function (component,event,helper)
    {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },

    onSelect : function (component, event, helper) {

        var cbs = component.find("radioId");
        for (var i = 0; i < cbs.length; i++) {
            cbs[i].set("v.checked",false);
            }

        var selectedId = event.getSource().get("v.name");
        event.getSource().set("v.checked",true);
        component.set("v.selectedRecordTypeId",selectedId);
    },

    createNewRecord : function (component, event, helper) {
        
        component.getConcreteComponent().createRecordMethod();
    },

})