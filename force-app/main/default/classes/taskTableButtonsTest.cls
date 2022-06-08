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
    User owner = resources.get(0);
    Task__c task = tasks.get(0);
    String taskId = Id.valueOf(task.Id);
    Task__c task2 = tasks.get(1);
    String task2Id = Id.valueOf(task2.Id);
    Task__c task3 = tasks.get(2);
    String task3Id = Id.valueOf(task3.Id);
    Test.startTest();
    System.assertEquals(UNINITIALIZED, task.State__c);
    System.runAs(owner) {
      taskTableButtons.changeTaskState(taskId, IN_PROGRESS);
    }
    task = [SELECT State__c FROM Task__c WHERE Id = :taskId];
    System.assertEquals(
      IN_PROGRESS,
      task.State__c,
      'pasa la task a In Progress'
    );
    // segundo cambio
    task2.State__c = IN_PROGRESS;
    System.runAs(owner) {
      update task2;
      taskTableButtons.changeTaskState(task2Id, COMPLETED);
    }
    task2 = [SELECT State__c FROM Task__c WHERE ID = :task2Id];
    System.assertEquals(COMPLETED, task2.State__c, 'pasa la task a Completed');
    //tercer cambio
    Boolean throwsError = false;
    try {
      System.runAs(owner) {
        taskTableButtons.changeTaskState(task3Id, 'asdhsafh');
      }
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
  @isTest
  static void registerHours() {
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
    User owner = resources.get(0);
    Task__c task = tasks.get(0);
    String taskId = Id.valueOf(task.Id);
    Task__c task2 = tasks.get(1);
    String task2Id = Id.valueOf(task2.Id);
    Task__c task3 = tasks.get(2);
    String task3Id = Id.valueOf(task3.Id);
    Test.startTest();
    System.runAs(owner) {
      taskTableButtons.registerHours(taskId, 5);
    }
    task = [SELECT Worked_Hours__c FROM Task__c WHERE Id = :taskId];
    System.assertEquals(
      5,
      task.Worked_Hours__c,
      'Agrega la cantidad adecuada de horas'
    );
    //segundo intento
    System.runAs(owner) {
      taskTableButtons.registerHours(task2Id, 5);
      taskTableButtons.registerHours(task2Id, 20);
    }
    task2 = [SELECT Worked_Hours__c FROM Task__c WHERE Id = :task2Id];
    System.assertEquals(
      25,
      task2.Worked_Hours__c,
      'cuando ya hay horas, las suma bien'
    );
    //tercer intento
    Boolean throwsError = false;
    try {
      System.runAs(owner) {
        taskTableButtons.registerHours(task2Id, 10);
        taskTableButtons.registerHours(task3Id, null);
      }
    } catch (Exception e) {
      throwsError = true;
    }
    System.assertEquals(
      true,
      throwsError,
      'no admite null como cantidad de horas'
    );
    task3 = [SELECT Worked_Hours__c FROM Task__c WHERE Id = :task3Id];
    System.assertEquals(
      null,
      task3.Worked_Hours__c,
      'si el parametro horas es null, no altera el valor anterior'
    );

    Test.stopTest();
  }
}