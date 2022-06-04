@isTest
public with sharing class taskTableButtonsTest {
  static final String UNINITIALIZED = 'Uninitialized';
  static final String IN_PROGRESS = 'In Progress';
  static final String COMPLETED = 'Completed';
  @isTest
  static void changesTaskState() {
    Integer numOfProjects = 1;
    Integer numOfResources = 1;
    Integer numOfTasks = 3;
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
    Task__c task2 = tasks.get(1);
    String task2Id = Id.valueOf(task2.Id);
    Task__c task3 = tasks.get(2);
    String task3Id = Id.valueOf(task3.Id);
    Test.startTest();
    System.assertEquals(UNINITIALIZED, task.State__c);
    taskTableButtons.changeTaskState(taskId, IN_PROGRESS);
    task = [SELECT State__c FROM Task__c WHERE Id = :taskId];
    System.assertEquals(
      IN_PROGRESS,
      task.State__c,
      'pasa la task a In Progress'
    );
    // segundo cambio
    task2.State__c = IN_PROGRESS;
    update task2;
    taskTableButtons.changeTaskState(task2Id, COMPLETED);
    task2 = [SELECT State__c FROM Task__c WHERE ID = :task2Id];
    System.assertEquals(COMPLETED, task2.State__c, 'pasa la task a Completed');
    //tercer cambio
    Boolean throwsError = false;
    try {
      taskTableButtons.changeTaskState(task3Id, 'asdhsafh');
    } catch (Exception e) {
      throwsError = true;
    }
    System.assertEquals(
      true,
      throwsError,
      'no admite estados distintos a los permitidos'
    );

    Test.stopTest();
  }
}
