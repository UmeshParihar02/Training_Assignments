public class DropDownAuraApex {

    /**
description: this method  query the institute records from the database
params : none
returns : Returns the institute records fetched by the query
**/   @AuraEnabled
    public static List<Institute__c> getInstitute_c(){
        List<Institute__c> instituteList = [Select ID , Name From Institute__c limit 20];
        return instituteList;
         
    }
    
    /**
description: this method  query the mentor records from the database
params : Institute Id
returns : Returns the mentor records fetched by the query
**/   @AuraEnabled
    public static List<mentor__c> getMentor(ID instituteId){
        system.debug('instituteId '+instituteId);
        List<Mentor__c> mentors = [SELECT ID, Name, Institute__c,Designation__c,Student_Number__c FROM Mentor__c WHERE Institute__c = :instituteId];
                system.debug('mentors '+mentors);

        return mentors;
         
    }
    
    /**
description: this method  query the students records from the database
params : Mentor Id 
returns : Returns the records fetched by the query
**/   @AuraEnabled
    public static List<Student__c> getStudent(ID mentorId){
        system.debug('menterId '+ mentorId);
        List<Student__c> students = [SELECT ID, Name , Mentor__c, Class__c , State__c FROM Student__c WHERE Mentor__c = : mentorId];
                system.debug('Student '+students);

        return students;
         
    }


}