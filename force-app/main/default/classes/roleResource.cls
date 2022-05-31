public with sharing class roleResource {
    @AuraEnabled(cacheable=true)
    public static Map<string, List<user>> allRoleResource(String strRecordId){
        id recordId = Id.valueOf(strRecordId);
        //Fechas del Proyecto
        List<Project__c> fechas =[SELECT Start_Date__c, End_Date__c FROM Project__c WHERE Project__c.Id=: recordId ];

        //Listar recursos ocupados 
        // List<Resource_Project__c> recPro=[SELECT Resource__c, Project__r.Start_Date__c,Project__r.End_Date__c FROM Resource_Project__c WHERE star y end  dates entre fehcas del Porject];

        //Filtrar Recursos disponibles 

        List<user> recursos =[SELECT FirstName, LastName, userrole.name, Rate_P_Hour__c FROM user WHERE userrole.name != null ];

        
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