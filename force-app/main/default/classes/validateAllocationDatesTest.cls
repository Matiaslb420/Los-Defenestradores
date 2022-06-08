@isTest
public with sharing class validateAllocationDatesTest {
  @isTest
  static void checkInsert() {
    Integer numOfProjects = 1;
    Integer numOfResources = 1;
    List<Project__c> projects = TestTaskDataFactory.createProjects(
      numOfProjects
    );
    List<Project__c> projects2 = TestTaskDataFactory.createProjects(
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

    Test.startTest();
    Resource_Project__c newRP = TestTaskDataFactory.createSingleResourceProject(
      projects.get(0).Id,
      resources.get(0).Id,
      Date.today(),
      Date.today().addDays(7)
    );
    Resource_Project__c rPInDataBase = [
      SELECT Id
      FROM Resource_Project__c
      WHERE Id = :newRP.Id
    ];
    System.assert(
      rPInDataBase != null,
      'permite asignar a un proyecto en fechas validas'
    );
    Boolean throwsError = false;
    try {
      newRP = TestTaskDataFactory.createSingleResourceProject(
        projects2.get(0).Id,
        resources.get(0).Id,
        Date.today().addDays(1),
        Date.today().addDays(8)
      );
    } catch (Exception e) {
      throwsError = true;
    }
    System.assert(
      throwsError,
      'evita que asigne a un recurso a una fecha invalida'
    );
    Test.stopTest();
  }

  @isTest
  static void checkUpdate() {
    Integer numOfProjects = 1;
    Integer numOfResources = 1;
    List<Project__c> projects = TestTaskDataFactory.createProjects(
      numOfProjects
    );
    List<Project__c> projects2 = TestTaskDataFactory.createProjects(
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

    Test.startTest();
    Resource_Project__c newRP = TestTaskDataFactory.createSingleResourceProject(
      projects.get(0).Id,
      resources.get(0).Id,
      Date.today(),
      Date.today().addDays(7)
    );

    Resource_Project__c newRP2 = TestTaskDataFactory.createSingleResourceProject(
      projects.get(0).Id,
      resources.get(0).Id,
      Date.today().addDays(8),
      Date.today().addDays(14)
    );
    Boolean thorwsError = false;
    newRP.Start_Date__c = Date.today().addDays(9);
    newRP.End_Date__c = Date.today().addDays(4);
    try {
      update newRP;
    } catch (Exception e) {
      thorwsError = true;
    }
    System.assert(thorwsError, 'no permite editar a fechas invalidas');
    thorwsError = false;
    newRP.Start_Date__c = Date.today().addDays(15);
    newRP.End_Date__c = Date.today().addDays(30);
    try {
      update newRP;
    } catch (Exception e) {
      thorwsError = true;
    }
    System.assert(!thorwsError, 'permite editar si la fecha es valida');

    thorwsError = false;
    newRP.Start_Date__c = Date.today().addDays(-3);
    newRP.End_Date__c = Date.today().addDays(14);
    try {
      update newRP;
    } catch (Exception e) {
      thorwsError = true;
    }
    System.assert(
      thorwsError,
      'no permite editar si la primer fecha es invalida'
    );
    Test.stopTest();
  }
}