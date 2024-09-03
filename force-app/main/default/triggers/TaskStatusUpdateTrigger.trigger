trigger TaskStatusUpdateTrigger on Maintenance_Request__c (before update) {
    for (Maintenance_Request__c task : Trigger.new) {
        if (task.Task_Completed__c==true && task.Status__c == 'In Progress') {
            task.Status__c = 'Closed';
        }
    }
}