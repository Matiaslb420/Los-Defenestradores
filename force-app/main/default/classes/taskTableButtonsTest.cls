@isTest
public with sharing class taskTableButtonsTest {
  static final String UNINITIALIZED = 'Uninitialized';
  static final String IN_PROGRESS = 'In Progress';
  static final String COMPLETED = 'Completed';
  @isTest
  static void changesTaskState() {
    Integer numOfProjects = 1;
    Integer numOfResources = 1;
    Integer numOfTasks = 5;
    List<Project__c> projects = TestTaskDataFactory.createProjects(
      numOfProjects
    );
    List<User> resources = TestTaskDataFactory.createBulkUsers(
      projects,
      numOfResources
    );
    List<Resource_Project__c> resPros = TestTaskDataFactory.createResourceProjects(
      projects,
      resources,
      numOfResources
    );
    List<Task__c> tasks = TestTaskDataFactory.createTasks(resPros, numOfTasks);
    Task__c task = tasks.get(0);
    String taskId = Id.valueOf(task.Id);
    Test.startTest();
    System.assertEquals(UNINITIALIZED, task.State__c);
    taskTableButtons.changeTaskState(taskId, COMPLETED);
    task = [SELECT State__c FROM Task__c WHERE Id = :taskId];
    System.assertEquals(COMPLETED, task.State__c, 'El valor fue cambiado');
    Test.stopTest();
  }
}
