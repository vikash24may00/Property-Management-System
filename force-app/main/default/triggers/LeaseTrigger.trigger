trigger LeaseTrigger on Lease__c (after insert, after update) {
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        LeaseTriggerHandler.updatePropertyStatus(Trigger.new);
        LeaseTriggerHandler.handleLeaseExpiration(Trigger.new);
    }
}