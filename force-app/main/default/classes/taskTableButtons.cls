public with sharing class taskTableButtons {
    @AuraEnabled(cacheable=false)
    public static Task__c initializeTask(String taskIdStr){
        try {
            Id taskId = Id.valueOf(taskIdStr);
            Task__c task = [SELECT State__c FROM Task__c WHERE Id =: taskId];
            task.State__c = 'In Progress';
            update task;
            return task;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}

/*
try {
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
*/