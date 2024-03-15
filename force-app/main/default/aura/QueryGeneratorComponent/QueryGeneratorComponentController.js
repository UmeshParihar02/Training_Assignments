({
    
    init: function(component, event, helper) {
       
        var action = component.get("c.getObjectOptions");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               console.log(' retrieve object options: ' + response.getReturnValue());
               component.set("v.objectOptions", response.getReturnValue());
            } else {
                console.log('Failed to retrieve object options: ' + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    getFields : function(component, event, helper) {
        component.set("v.tableLabel",[]);
        
        //if we change the object from picklist the dual-listbox(2) will be empty 
        component.set("v.selectedFields",[]);
        
        //if we change the object from picklist the textArea will be empty  
        component.set("v.QueryFormat",[]);
        
        var selectedObject = component.get("v.selectedObject");
        var action = component.get("c.getObjectFields");
        console.log("selected object "+selectedObject);
        action.setParams({"objectName": selectedObject });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('selected object records '+response.getReturnValue())
                component.set("v.fieldOptions", response.getReturnValue());
            }else { console.log('selected object records are empty '); }
            // Handle errors
        });
        $A.enqueueAction(action);
    },

    getselectFields : function(component, event, helper) {
        var selectedFields = event.getParam("value");
        console.log('selected fields'+selectedFields);
        component.set("v.selectedFields", selectedFields);
    },
    
       forQueryClick: function(component, event, helper) {
        var objectName = component.get("v.selectedObject");
       var selectedField = component.get("v.selectedFields");
        var  soqlQuery = 'SELECT '+selectedField.join(', ')+' '+'FROM '+objectName;
        component.set("v.QueryFormat",soqlQuery);
        
       console.log("selected object "+soqlQuery);
    },
    
    cilkForRecords: function(component, event, helper) {
        debugger;
        var objectName = component.get("v.selectedObject");
        var selectedField = component.get("v.selectedFields");
        var tableRecords = [];
        console.log(selectedField);
        
       selectedField.forEach(function(field) {
           //field = field.charAt(0).toUpperCase()+field.substring(1);
         tableRecords.push({ label: field, fieldName: field, type: "string" });
       });
            //tableRecords.push({ label: "Id", fieldName: "Id", type: "String" });
            //tableRecords.push({ label: "Name", fieldName: "Name", type: "String" });


        component.set("v.tableLabel",tableRecords);
        console.log('selected object fields lable '+tableRecords)
        
        var action = component.get("c.getQueryRecords");
       
        action.setParams({objectName: objectName, fields: selectedField});
        action.setCallback(this, function(data) {
             var state = data.getState();
             if (state === "SUCCESS") {
                 
               		 console.log('selected object fields '+data.getReturnValue())
                     component.set("v.tabledata", data.getReturnValue());
                    
                     var data = component.get("v.tabledata");
                     console.log(data);
             }else
                   { console.error("Failed to fetch data: " + state);} 
        });
        $A.enqueueAction(action);
    }
          
})