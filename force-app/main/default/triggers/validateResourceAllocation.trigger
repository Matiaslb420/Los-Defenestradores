trigger validateResourceAllocation on Resource_Project__c(
  before insert,
  before update
) {
  if (Trigger.isInsert) {
    for (
      Resource_Project__c invalidRP : validateAllocationDates.onInsert(
        Trigger.new
      )
    ) {
      invalidRP.addError(
        'la fecha es Invalida, se superpone con otro proyecto'
      );
    }
  } else if (Trigger.isUpdate) {
    for (
      Resource_Project__c invalidRP : validateAllocationDates.onUpdate(
        Trigger.old,
        Trigger.new
      )
    ) {
      invalidRP.addError(
        'la fecha es Invalida, se superpone con otro proyecto'
      );
    }
  }
}