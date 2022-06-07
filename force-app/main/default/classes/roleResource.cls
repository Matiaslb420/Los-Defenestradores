public with sharing class roleResource {
  @AuraEnabled(cacheable=false)
  public static Map<string, List<user>> allRoleResource(String strRecordId) {
    id recordId = Id.valueOf(strRecordId);
    //Fechas del Proyecto
    Project__c fechas = [
      SELECT Start_Date__c, End_Date__c
      FROM Project__c
      WHERE Project__c.Id = :recordId
    ];

    //Set Ids de Resourse Project
    List<Resource_Project__c> resProject = [
      SELECT Resource__c
      FROM Resource_Project__c
      WHERE
        Start_Date__c = NULL
        OR End_Date__c = NULL
        OR (Start_Date__c >= :fechas.Start_Date__c
        AND Start_Date__c <= :fechas.End_Date__c)
        OR (End_Date__c >= :fechas.Start_Date__c
        AND End_Date__c <= :fechas.End_Date__c)
    ];

    Set<Id> recIds = new Set<Id>();

    for (Resource_Project__c rp : resProject) {
      recIds.add(rp.Resource__c);
    }

    List<Project_Line_Item__c> allProjectRoles = [
      SELECT Role__c, Sold_Role_Hours__c
      FROM Project_Line_Item__c
      WHERE Project__r.id = :recordId
      ORDER BY Role__c
    ];

    Set<string> pliRoles = new Set<string>();

    for (Project_Line_Item__c pliR : allProjectRoles) {
      pliRoles.add(pliR.Role__c);
    }

    //Lista de Recursos disponibles
    List<user> recursos = [
      SELECT FirstName, LastName, userrole.name, Rate_P_Hour__c
      FROM user
      WHERE
        userrole.name != NULL
        AND user.Id NOT IN :recIds
        AND userrole.name IN :pliRoles
      ORDER BY userrole.name ASC
    ];

    //Listar recursos ocupados

    Map<string, List<user>> recursosByRole = new Map<string, List<user>>();

    for (Project_Line_Item__c u : allProjectRoles) {
      if (!recursosByRole.containsKey(u.Role__c)) {
        recursosByRole.put(u.Role__c, new List<user>());
      }
    }

    for (User u : recursos) {
      recursosByRole.get(u.userrole.name).add(u);
    }

    return recursosByRole;
  }
}
