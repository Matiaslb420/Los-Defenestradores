public with sharing class taskTableButtons {
  @AuraEnabled(cacheable=false)
  public static Task__c changeTaskState(String taskIdStr, String newState) {
    Id taskId = Id.valueOf(taskIdStr);
    Task__c task = [SELECT State__c FROM Task__c WHERE Id = :taskId];
    task.State__c = newState;
    update task;
    return task;
    /*try {
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }*/
  }

  @AuraEnabled(cacheable=false)
  public static Task__c registerHours(String taskIdStr, Integer hours) {
    Id taskId = Id.valueOf(taskIdStr);
    try {
      Task__c task = [
        SELECT Id, Worked_Hours__c
        FROM Task__c
        WHERE Id = :taskId
      ];
      if (task.Worked_Hours__c != null) {
        task.Worked_Hours__c += hours;
      } else {
        task.Worked_Hours__c = hours;
      }
      update task;
      return task;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
