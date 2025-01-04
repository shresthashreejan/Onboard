({
    showToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": component.get("v.toastTitle"),
            "message": component.get("v.toastMessage"),
            "type": component.get("v.toastType")
        });
        toastEvent.fire();
    }
})