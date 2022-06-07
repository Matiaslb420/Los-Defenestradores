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
    /*
    List<Resource_Project__c> resPros = TestTaskDataFactory.createResourceProjects(
      projects,
      resources,
      numOfResources
    );
    for(Resource_Project__c resPro : resPros){
      resPro.Start_Date__c = Date.today();
      resPro.End_Date__c = Date.today().addDays(7);
    }
    update resPros;
    */
    Test.startTest();
    Map<String, List<user>> ResourcesByRole = roleResource.allRoleResource(
      projects.get(0).Id
    );
    Boolean allUsersPresent = false;
    for (User user : resources) {
      for (User u : ResourcesByRole.get(user.UserRole.Name)) {
        if (u.Id == user.Id) {
          allUsersPresent = true;
          break;
        }
      }
      if (allUsersPresent == false) {
        break;
      }
      allUsersPresent = true;
    }
    Test.stopTest();
  }
}
