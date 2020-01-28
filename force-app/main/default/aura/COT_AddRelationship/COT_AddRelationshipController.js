({

   doInit : function(component,event,helper)
   {
        component.set("v.startLoadingData",true);
   },

    createRecord : function (component, event, helper) {
        helper.createRecord(component);
    },


})