public class DropDownController {

    public String selectedValue { get; set; }
    public String selectedMentorId { get; set; }
    public List<SelectOption> dropdownOptions { get; set; }
    public List<Mentor__c> mentors { get; set; }
    public List<Student__c> students { get; set; }

    
    public DropDownController() 
    {
        dropdownOptions = new List<SelectOption>();
        dropdownOptions.add(new SelectOption('', 'None'));
        for(Institute__c inst : [SELECT Id, Name FROM Institute__c])
        {
            
            dropdownOptions.add(new SelectOption(inst.Id, inst.Name));
            
            selectedValue = Null;
        }
    }
      public void fetchMentors()
       {
        // Fetch mentors for the selected institute
        mentors = [SELECT Id, Name, Designation__c,Student_Number__c FROM Mentor__c WHERE Institute__c = :selectedValue];
           students=null;
 
    }
    
      public void fetchStudents()
       {
        System.debug(selectedMentorId);
        students= [SELECT Id, Name, Class__c,City__c,State__c FROM Student__c WHERE Mentor__c  = :selectedMentorId];
        System.debug(students);
           
    }
}