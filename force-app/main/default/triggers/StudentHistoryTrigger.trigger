trigger StudentHistoryTrigger on Student__c ( after update  ) 
{
   
    //for storing data in student history object
    List<Student_History__c> historyRecords = new List<Student_History__c>();

    // Get the field details using Metadata API
    Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Student__c.fields.getMap();

    for (Student__c oldStudent : Trigger.old) {
        Student__c newStudent = Trigger.newMap.get(oldStudent.Id);

        for (String fieldName : fieldMap.keySet()) {
            Schema.SObjectField field = fieldMap.get(fieldName);
            Object oldValue = oldStudent.get(fieldName);
            Object newValue = newStudent.get(fieldName);

            if (oldValue != newValue) {
                historyRecords.add(new Student_History__c(
                    Student__c = oldStudent.Id,
                    Name = field.getDescribe().getLabel(),// field is the instance of schemasObject and getdiscribe is metadata about fields and getlabel is value of metadata . 
                    Old_Value__c = String.valueOf(oldValue),
                    New_Value__c = String.valueOf(newValue),
                    Record_Id__c = oldStudent.Id
                ));
            }
        }
    }

    if (!historyRecords.isEmpty()) {
        insert historyRecords;
    }


}