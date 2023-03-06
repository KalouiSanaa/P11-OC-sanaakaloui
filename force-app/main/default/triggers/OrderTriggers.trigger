/*
Ce déclencheur (trigger) se déclenche avant la mise à jour et après l'insertion ou la suppression d'un enregistrement d'Order.
*/
trigger OrderTriggers on Order (Before Update,after insert,After Delete) {
    
    // Si le trigger est déclenché par une mise à jour, appeler la méthode handleBeforeUpdate de la classe OrderTriggersHandler
    try{
        if (Trigger.isUpdate && trigger.isBefore) {
            OrderTriggersHandler.handleBeforeUpdate(Trigger.new,Trigger.oldMap);
        }
    
        if (Trigger.isInsert || Trigger.isDelete) {
            
            // Si le trigger est déclenché par une insertion ou une suppression, appeler la méthode handlerAfterDelete de la classe OrderTriggersHandler
            OrderTriggersHandler.handlerAfterDelete(Trigger.old);
        }
    }
    
    catch(exception ex){
        system.debug(ex.getMessage());
    }
}