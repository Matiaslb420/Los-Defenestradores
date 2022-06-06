public with sharing class validateAllocationDates {
  //revisar si un resource project tiene las fechas superpuestas con otro
  public static Boolean checkValidDate(
    Resource_Project__c newRP,
    Resource_Project__c oldRP
  ) {
    if (
      newRp.Start_Date__c >= oldRP.Start_Date__c &&
      newRp.Start_Date__c <= oldRP.End_Date__c
    ) {
      return false;
    }
    if (
      newRp.End_Date__c >= oldRP.Start_Date__c &&
      newRp.End_Date__c <= oldRP.End_Date__c
    ) {
      return false;
    }
    return true;
  }

  public static List<Resource_Project__c> onInsert(
    List<Resource_Project__c> newresPros
  ) {
    //genero un set con las id de recursos
    Set<Id> resources = new Set<Id>();
    for (Resource_Project__c rp : newresPros) {
      resources.add(rp.Resource__c);
    }
    //traigo todos sus Resource_Project__c
    List<Resource_Project__c> allResProsSchedules = [
      SELECT Resource__c, Start_Date__c, End_Date__c, Project__r.Status__c
      FROM Resource_Project__c
      WHERE Resource__c IN :resources AND Project__r.Status__c = 'In Progress'
    ];
    //genero un mata key:Resource__c.Id, value: lista de sus resource_Project__c
    Map<Id, List<Resource_Project__c>> scheduledDatesByResource = new Map<Id, List<Resource_Project__c>>();
    for (Resource_Project__c rp : allResProsSchedules) {
      if (scheduledDatesByResource.containsKey(rp.Resource__c)) {
        scheduledDatesByResource.get(rp.Resource__c).add(rp);
      } else {
        scheduledDatesByResource.put(
          rp.Resource__c,
          new List<Resource_Project__c>{ rp }
        );
      }
    }
    //reviso cada RP ingresante con sus RP ya existentes, los invalidos serán retornados
    List<Resource_Project__c> invalidResourceProjects = new List<Resource_Project__c>();
    for (Resource_Project__c newRP : newresPros) {
      if (scheduledDatesByResource.containsKey(newRP.Resource__c)) {
        for (
          Resource_Project__c rp : scheduledDatesByResource.get(
            newRP.Resource__c
          )
        ) {
          if (!validateAllocationDates.checkValidDate(newRP, rp)) {
            invalidResourceProjects.add(newRP);
          }
        }
      }
    }
    return invalidResourceProjects;
  }

  public static List<Resource_Project__c> onUpdate(
    List<Resource_Project__c> oldRespros,
    List<Resource_Project__c> newResPros
  ) {
    //genero 2 sets con las ids de los viejos y nuevos RP
    Set<Id> resources = new Set<Id>();
    Set<Id> oldResources = new Set<Id>();
    for (Integer indexRP = 0; indexRP < newResPros.size(); indexRP++) {
      resources.add(newResPros.get(indexRP).Resource__c);
      oldResources.add(oldRespros.get(indexRP).Resource__c);
    }
    //traigo los resource project relacionados por usuario
    List<Resource_Project__c> allResProsSchedules = [
      SELECT Resource__c, Start_Date__c, End_Date__c, Project__r.Status__c
      FROM Resource_Project__c
      WHERE Resource__c IN :resources AND Project__r.Status__c = 'In Progress'
    ];
    //vinculo los resource project en un mapa, con el Resource__c como key
    //ignorando los viejos valores en la actualización
    Map<Id, List<Resource_Project__c>> scheduledDatesByResource = new Map<Id, List<Resource_Project__c>>();
    for (Resource_Project__c rp : allResProsSchedules) {
      if (oldResources.contains(rp.Id)) {
        //evita que al actualizar, no se compare la fecha con la version antertior
        continue;
      }
      if (scheduledDatesByResource.containsKey(rp.Resource__c)) {
        scheduledDatesByResource.get(rp.Resource__c).add(rp);
      } else {
        scheduledDatesByResource.put(
          rp.Resource__c,
          new List<Resource_Project__c>{ rp }
        );
      }
    }
    //reviso cada RP ingresante con sus RP ya existentes, retornando los invalidos
    List<Resource_Project__c> invalidResourceProjects = new List<Resource_Project__c>();
    for (Resource_Project__c newRP : newresPros) {
      if (scheduledDatesByResource.containsKey(newRP.Resource__c)) {
        for (
          Resource_Project__c rp : scheduledDatesByResource.get(
            newRP.Resource__c
          )
        ) {
          if (!validateAllocationDates.checkValidDate(newRP, rp)) {
            invalidResourceProjects.add(newRP);
          }
        }
      }
    }
    return invalidResourceProjects;
  }
}
