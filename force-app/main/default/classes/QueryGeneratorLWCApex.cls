public class QueryGeneratorLWCApex {
    
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