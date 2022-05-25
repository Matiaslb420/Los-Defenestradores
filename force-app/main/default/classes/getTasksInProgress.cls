public with sharing class getTasksInProgress {
    @AuraEnabled(cacheable=true)
    public static Map<String, List<Task__c>> getResourceTasks(Id ResourceId) {
        /*
        Se consigue un mapa de nombres de proyectos con la Id del resource_Project como key
        y una lista de todas las tareas del recurso
        */
        Map<Id, Resource_Project__c> ProjectNamesByResourceProjectId = new Map<Id, Resource_Project__c>([SELECT Id, Project__r.Name FROM Resource_Project__c WHERE  Resource__c =: ResourceId]);
        List<Task__c> resourceTasks = [
            SELECT 
                Name, 
                State__c, 
                Quantity_Hours__c, 
                Worked_Hours__c,
                Resource_Project__c
            FROM Task__c
            WHERE Resource_Project__c in: ProjectNamesByResourceProjectId.keySet()
        ];
        //se agrupan todas las tareas por proyecto en un mapa y se retorna ese mapa
        Map<String, List<Task__c>> tasksByProjectName = new Map<String, List<Task__c>>();
        for(Task__c task : resourceTasks){
            String ProjectName = ProjectNamesByResourceProjectId.get(task.Resource_Project__c).Project__r.Name;
            if(TasksByProjectName.containsKey(ProjectName)){
                TasksByProjectName.get(ProjectName).add(task);
            }
            else{
                TasksByProjectName.put(ProjectName, new List<Task__c>{task});
            }
        }
        return tasksByProjectName;
    }
}