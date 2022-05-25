@isTest
public with sharing class getTasksInProgressTest {
    @isTest static void getsTheTasks() {
        Integer numOfProjects = 1;
        Integer numOfResources = 1;
        Integer numOfTasks = 2;
        List<Project__c> projects = TestTaskDataFactory.createProjects(numOfProjects);
        List<User> resources = TestTaskDataFactory.createBulkUsers(projects, numOfResources);
        List<Resource_Project__c> resPros = TestTaskDataFactory.createResourceProjects(projects, resources, numOfResources);
        List<Task__c> tasks = TestTaskDataFactory.createTasks(resPros, numOfTasks);
        User res = resources.get(0);
        Resource_Project__c resPro = resPros.get(0);
        Project__c project = [SELECT Id, Name FROM Project__c WHERE Id =: resPro.Project__c];
        
        Test.startTest();
        Map<String, List<Task__c>> testTasks = getTasksInProgress.getResourceTasks(resPro.Resource__c);
        System.assertEquals(1, testTasks.size(), 'Encontró el proyecto');
        System.assertEquals(2, testTasks.get(project.Name).size(), 'Encontró las tareas');
        test.stopTest();
    }
    @isTest static void withMultipleProjects(){
        Integer numOfProjects = 2;
        Integer numOfResources = 1;
        Integer numOfTasks = 5;
        List<Project__c> projects = TestTaskDataFactory.createProjects(numOfProjects);
        List<User> resources = TestTaskDataFactory.createBulkUsers(projects, numOfResources);
        List<User> sameResource = new List<User>{resources.get(0), resources.get(0)};
        List<Resource_Project__c> resPros = TestTaskDataFactory.createResourceProjects(projects, sameResource, numOfResources);
        List<Task__c> tasks = TestTaskDataFactory.createTasks(resPros, numOfTasks);

        Resource_Project__c resPro = resPros.get(0);
        Resource_Project__c resPro2 = resPros.get(1);

        List<Project__c> project = [SELECT Id, Name FROM Project__c WHERE Id =: resPro.Project__c OR Id =: resPro2.Project__c];
        Test.startTest();
        Map<String, List<Task__c>> testTasks = getTasksInProgress.getResourceTasks(resPro.Resource__c);
        System.assertEquals(2, testTasks.size(), 'Encontró el proyecto');
        System.assertEquals(5, testTasks.get(project.get(0).Name).size(), 'Encontró las tareas');
        test.stopTest();
    }
}