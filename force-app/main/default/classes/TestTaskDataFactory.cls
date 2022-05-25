@isTest
public with sharing class TestTaskDataFactory {
    public static List<Project__c> createProjects(Integer numOfProjects){
        Opportunity sampleOp = new Opportunity(Name = 'SampleOp', StageName = 'Closed Won', CloseDate = Date.today());
        insert sampleOp;
        List<Project__c> projects = new List<Project__c>();
        for(Integer p = 0; p < numOfProjects; p++){
            Project__c pro = new Project__c(Name = 'Project' + p, Opportunity__c = sampleOp.Id);
            projects.add(pro);
        }
        insert projects;
        return projects;
    }
    public static User createUser(Integer resourceIndex, Id profileId){
        User resource = new User(
                    lastName = 'testUser'+ resourceIndex, 
                    Username = 'test' + resourceIndex + '@LosDefenestradoresTest.com',
                    email = 'test' + resourceIndex + '@test.com', 
                    alias = 'Tcode' + resourceIndex,
                    CommunityNickname = 'Tcode' + resourceIndex,
                    LocaleSidKey = 'en_US',
                    TimeZoneSidKey = 'GMT',
                    ProfileId = profileId,
                    LanguageLocaleKey = 'en_US',
                    EmailEncodingKey = 'UTF-8'
                );
        return resource;
    }
    public static List<User> createBulkUsers(List<Project__c> projects, Integer numOfResources){
        Integer index = 0;
        Profile profileId = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        List<User> resources = new List<User>();
        for (Project__c pro : projects){
            for(Integer r = 0; r < numOfResources; r++){
                User newUser = TestTaskDataFactory.createUser(index++, profileId.Id); 
                resources.add(newUser);
            }
        }
        insert resources;
        return resources;
    }
    public static List<Resource_Project__c> createResourceProjects(List<Project__c> projects, List<User> resources, Integer numOfResources){
        List<Resource_Project__c> resPros = new List<Resource_Project__c>();
        Integer ResourceIndex = 0;
        for(Project__c pro : projects){
            for(Integer r = 0; r < numOfResources; r++){
                User res = resources.get(ResourceIndex);
                ResourceIndex++;
                Resource_Project__c newResPro = new Resource_Project__c(
                    Project__c = pro.Id, 
                    Resource__c = res.Id,
                    Worked_Hours__c = 50,
                    Required_Hours__c = 200
                    );
                resPros.add(newResPro);
            }
        }
        insert ResPros;
        return ResPros;
    }
    public static List<Task__c> createTasks(List<Resource_Project__c> resPros, Integer numOfTasks){
        List<Task__c> tasks = new List<Task__c>();
        for (Resource_Project__c resPro : resPros){
            for(Integer t = 0; t < numOfTasks; t++){
                Task__c task = new Task__c(
                    Name = 'TaskTest' + t,
                    Quantity_Hours__c = 10,
                    Resource_Project__c = resPro.Id,
                    State__c = 'In Progress',
                    Worked_Hours__c = 5
                );
                tasks.add(task);
            }
        }
        insert tasks;
        return tasks;
    }
}