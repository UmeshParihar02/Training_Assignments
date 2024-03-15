({
    // method for institute drop down 
     doInit  : function(component, event, helper) {
       var action = component.get("c.getInstitute_c");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('institute recodes'+response.getReturnValue());
                component.set("v.ObjectsList", response.getReturnValue());
            }else {console.log('institute recodes are empty');}
        });
        $A.enqueueAction(action);
    }, 
    
    // method for mentors of selected institute 
    selectedInstitute : function(component, event, helper) {
        var instituteId = event.getSource().get("v.value");
        
        if(instituteId === "")
        {
            component.set("v.mentors" , []);
            component.set("v.students" , []);
        }
        else{
            component.set("v.students" , []);
        console.log('instituteId '+ instituteId);
        var action = component.get("c.getMentor");
        action.setParams({"instituteId": instituteId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(response);
                        console.log(response.getReturnValue());
            console.log(state);

            if (state == "SUCCESS") {
                console.log('mentors recodes'+response.getReturnValue());
                component.set("v.mentors", response.getReturnValue());
            }else {console.log('mentors recodes are empty');}
        });
        $A.enqueueAction(action);
        } }, 
    
    // method for students of releted mentor
    selectedMentor : function(component, event, helper) {
        var mentorId = event.currentTarget.dataset.mentorId;
        if(mentorId === ""){
            component.set("v.students" , []);
        }
        else{
        console.log('mentorId '+ mentorId);
        var action = component.get("c.getStudent");
        action.setParams({"mentorId": mentorId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            console.log(response);
                        console.log(response.getReturnValue());
            console.log(state);

            if (state == "SUCCESS") {
                console.log('students recodes avaliable '+response.getReturnValue());
                component.set("v.students", response.getReturnValue());
            }else {console.log('students recodes are empty');}
        });
        $A.enqueueAction(action);
        } } ,
    
        
    // Toggle logic to show/hide the student details for the clicked mentor
    toggleMentor: function(component, event, helper) {
    var mentorId = event.currentTarget.dataset.mentorId;
    var currentSelectedMentorId = component.get("v.selectedMentorId");
    
    var newSelectedMentorId = (currentSelectedMentorId === mentorId) ? "" : mentorId;
    component.set("v.selectedMentorId", newSelectedMentorId);
}
    	
    
})