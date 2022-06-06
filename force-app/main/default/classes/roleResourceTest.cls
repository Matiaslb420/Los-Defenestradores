@isTest
public with sharing class roleResourceTest {
  @isTest
  static void findsAllResources() {
    Integer numOfProjects = 1;
    Integer numOfResources = 10;
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
    Test.startTest();
    Map<String, List<user>> ResourcesByRole = roleResource.allRoleResource(
      projects.get(0).Id
    );
    System.assertEquals(
      10,
      ResourcesByRole.get('Arquitecto').size(),
      'encuentra a todos los usuarios'
    );

    Test.stopTest();
  }
}
