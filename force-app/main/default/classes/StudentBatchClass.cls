global class StudentBatchClass implements Database.Batchable<sObject>, Schedulable, Database.stateful
{
    // Use a Map to track counts of records marked for deletion by creator
    private Map<Id, Integer> creatorIdCounts = new Map<Id, Integer>();
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        //  the record was created more than 2 days ago
        DateTime twoDaysAgo = DateTime.now().addDays(-2);
        
        return Database.getQueryLocator(
                                          [Select CreatedById from Student__c 
                                          WHERE IsRegisterationCompleted__c = false 
                                          AND CreatedDate <= :twoDaysAgo]);
    }
    
    global void execute(Database.BatchableContext bc , list<Student__c> studentList)
    {
        // Process records
        for (Student__c std : studentList) {
            std.Mark_For_Delete__c = 'yes';
            creatorIdCounts.put(std.CreatedById, creatorIdCounts.get(std.CreatedById) != null ? creatorIdCounts.get(std.CreatedById) + 1 : 1);
        }
        update studentList;
    }
    
    
    global void finish(Database.BatchableContext bc)
    {
         // Fetch emails for all creators in one
        Map<Id, User> users = new Map<Id, User>([SELECT Id, Email FROM User WHERE Id IN : creatorIdCounts.keySet()]);

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for(Id creatorId : creatorIdCounts.keySet())
        {
            User user = users.get(creatorId);
            if(user.Email != null)
            {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[]{user.Email});
                mail.setSubject('Batch job completed - Students marked for deletion');
                mail.setPlainTextBody('The batch job has successfully completed. ' +
                                      'Total students marked for deletion: ' + creatorIdCounts.get(creatorId) +
                                      '. Please review the records marked for deletion.');
                emails.add(mail);          
            }
        }
        
           // Send emails in bulk
           if (!emails.isEmpty()) {
              Messaging.sendEmail(emails);
           }
    }
    
    global void execute(SchedulableContext sc)
    {
        StudentBatchClass ulb = new StudentBatchClass();
        DataBase.executeBatch(ulb);
    }

}