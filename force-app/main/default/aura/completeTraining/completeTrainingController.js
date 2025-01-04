({
    onInit : function(component, event, helper) {
        var action = component.get("c.fetchContentId");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.contentId", response.getReturnValue().contentId);
                component.set("v.resourceName", response.getReturnValue().name);
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.toastTitle", "Error");
                component.set("v.toastType", "error");
                if (errors && errors.length > 0) {
                    component.set("v.toastMessage", errors[0].message);
                } else {
                    component.set("v.toastMessage", "Error loading file previewer component.");
                }
                helper.showToast(component);
            }
        });
        $A.enqueueAction(action);
    },
    handleComplete : function(component, event, helper) {
        var action = component.get("c.completeTraining");
        action.setParams({
            recordId: component.get("v.recordId")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.toastTitle", "Success");
                component.set("v.toastType", "success");
                component.set("v.toastMessage", "Training has been completed.");
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.toastTitle", "Error");
                component.set("v.toastType", "error");
                if (errors && errors.length > 0) {
                    component.set("v.toastMessage", errors[0].message);
                } else {
                    component.set("v.toastMessage", "An error has occurred.");
                }
            }
            helper.showToast(component);
        });
        $A.enqueueAction(action);
    }
})