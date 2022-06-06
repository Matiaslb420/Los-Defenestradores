public with sharing class projectRoles {
  @AuraEnabled(cacheable=false)
  public static List<Project_Line_Item__c> allProjectRoles(String strRecordId) {
    id recordId = Id.valueOf(strRecordId);
    List<Project_Line_Item__c> allProjectRoles = [
      SELECT Role__c, Sold_Role_Hours__c
      FROM Project_Line_Item__c
      WHERE Project__r.id = :recordId
      ORDER BY Role__c ASC
    ];

    return allProjectRoles;
  }
}
