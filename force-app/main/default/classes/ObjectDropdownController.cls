public class ObjectDropdownController {
    // Wrapper class to hold object name and label
    
      @AuraEnabled
    public static List<String> getObjectOptions(){
        List<String> objects = new List<String>();
        
        List<Schema.SObjectType> data = Schema.getGlobalDescribe().Values();
        for(Schema.SObjectType sObjData : data){
            objects.add(sObjData.getDescribe().getName());
        }
        objects.sort();
        System.debug(objects);
        return objects;
    }
    
    
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getObjectFields(String objectName) {
        
        List<Map<String, String>> fieldsList = new List<Map<String, String>>();
            Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
            for (String fieldName : fieldMap.keySet()) {
                Map<String, String> fieldDetail = new Map<String, String>();
                fieldDetail.put('label', fieldMap.get(fieldName).getDescribe().getLabel());
                fieldDetail.put('value', String.valueof(fieldMap.get(fieldName)));
                fieldsList.add(fieldDetail);
            }
        return fieldsList;
    }
    
    /*
    //method to fetch all the fields of the selected object dynamically
    @AuraEnabled
    public static List<wrapper> getObjectFields(string objectName){
        //List to store labels and values of the fields because in duallist box we can store values in the 
        //form of label and value that's why created wrapper
        List<wrapper> fieldsList = new List<wrapper>();
        
        //Map to get the objects dynamically
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Schema.SObjectType sobjType = gd.get(objectName); 
        Schema.DescribeSObjectResult describeResult = sobjType.getDescribe(); 
        
        //map to get the fields dynmically
        Map<String,Schema.SObjectField> fieldsMap = describeResult.fields.getMap();
        for (String fieldName : fieldsMap.keySet()) {
            wrapper wrapperObject =new wrapper(); 
            wrapperObject.label = fieldName;
            wrapperObject.value = string.valueof(fieldsMap.get(fieldName));
            fieldsList.add(wrapperObject);
        }
        System.debug(fieldsList);
        return fieldsList;
    }
    
    //wrapper class to store field label and value
    public class wrapper{
        @auraEnabled public String label;
        @auraEnabled public String value;
    }
    */
    
   @AuraEnabled
public static List<SObject> getQueryRecords(String objectName, List<String> fields) {
    //  SOQL query with proper spacing
    System.debug('Fields are =>'+fields);
    String soqlQuery = 'SELECT ' + String.join(fields, ',') + ' FROM ' + objectName;
    soqlQuery.toUpperCase();
    // Execute query and return records
    //List<SObject> soqlRecords = Database.query(soqlQuery);
    //System.debug('Records: ' + soqlRecords);
    return Database.query(soqlQuery);
}
    
    
}