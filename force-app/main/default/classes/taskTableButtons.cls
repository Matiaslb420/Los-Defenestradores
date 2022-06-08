public with sharing class taskTableButtons {
  public virtual class CustomException extends Exception {
  }
  public class InvalidStateException extends CustomException {
  }
  public class HoursEqualNullException extends CustomException {
  }

  static final String UNINITIALIZED = 'Uninitialized';
  static final String IN_PROGRESS = 'In Progress';
  static final String COMPLETED = 'Completed';

  @AuraEnabled(cacheable=false)
  public static Task__c changeTaskState(String taskIdStr, String newState) {
    try {
      if (
        !newState.equals(UNINITIALIZED) &&
        !newState.equals(IN_PROGRESS) &&
        !newState.equals(COMPLETED)
      ) {
        throw new InvalidStateException('the new task state is invalid');
      }
      Id taskId = Id.valueOf(taskIdStr);
      Task__c task = [SELECT State__c FROM Task__c WHERE Id = :taskId];
      task.State__c = newState;
      update task;
      return task;
    } catch (Exception e) {
      throw new CustomException(e.getMessage());
    }
  }

  @AuraEnabled(cacheable=false)
  public static Task__c registerHours(String taskIdStr, Integer hours) {
    Id taskId = Id.valueOf(taskIdStr);
    try {
      if (hours == null) {
        throw new HoursEqualNullException(
          'la cantidad de horas no puede ser null'
        );
      }
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