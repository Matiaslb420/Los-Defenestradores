@isTest
public with sharing class projectRolesTest {
  @isTest
  static void projectRolesTest() {
    Integer numOfProjects = 1;
    List<Project__c> projects = TestTaskDataFactory.createProjects(
      numOfProjects
    );
    List<String> newRoles = new List<String>{
      'Cyber Security',
      'terapeuta de LWC',
      'el que hace los test',
      'Oscar'
    };

    Test.startTest();
    List<Project_Line_Item__c> searchedPLI = projectRoles.allProjectRoles(
      projects.get(0).Id
    );
    System.assertEquals(4, searchedPLI.size(), 'trae todos los roles');
    Test.stopTest();
  }
}