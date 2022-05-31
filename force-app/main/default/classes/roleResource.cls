public with sharing class roleResource {
    @AuraEnabled(cacheable=false)
    public static Map<string, List<user>> allRoleResource(String strRecordId){
        
        id recordId = Id.valueOf(strRecordId);    
        //Fechas del Proyecto
        Project__c fechas =[SELECT Start_Date__c, End_Date__c FROM Project__c WHERE Project__c.Id =: recordId];

        //List<Project__c> fechas =[SELECT Start_Date__c, End_Date__c FROM Project__c WHERE Project__c.Id =: recordId];

        //Date startDate= (Date)fechas[0].get('Start_Date__c');
        //Date endDate= (Date)fechas[0].get('End_Date__c');

        //Set Ids de Resourse Project
        List<Resource_Project__c> resProject = [
            SELECT Resource__c
            FROM Resource_Project__c 
            WHERE (
                    Project__r.Start_Date__c >=: fechas.Start_Date__c  
                    AND Project__r.Start_Date__c <=:  fechas.End_Date__c
                )OR 
                (
                     Project__r.End_Date__c >=: fechas.Start_Date__c 
                     AND Project__r.End_Date__c <=: fechas.End_Date__c
                )
                
        ];

        Set<Id> recIds= new Set<Id>();

        for(Resource_Project__c rp: resProject){
           recIds.add(rp.Resource__c); 
        }

       // Set<Id> resProjectIds = (new Map<Id,user>(resProject)).keySet();
        
        //Lista de Recursos disponibles
        List<user> recursos = [
            SELECT FirstName, LastName, userrole.name, Rate_P_Hour__c 
            FROM user 
            WHERE  userrole.name != null 
            AND user.Id NOT IN :recIds];
        
                
        //Listar recursos ocupados 
        
        Map<string, List<user>> recursosByRole = new Map<string, List<user>>();
        
        for (User u : recursos) {
            if (!recursosByRole.containsKey(u.userrole.name)) {
                recursosByRole.put(u.userrole.name,new List<user>());
            }
            recursosByRole.get(u.userrole.name).add(u);
        }

       return recursosByRole;
    }
}