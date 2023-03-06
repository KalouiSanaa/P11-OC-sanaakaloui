trigger OrderTriggers on Order (Before Update,after insert,After Delete) {
    try{
        if (Trigger.isUpdate) {
            OrderTriggersHandler.handleBeforeUpdate(Trigger.new,Trigger.oldMap);}
    else{
        if (Trigger.isInsert || Trigger.isDelete) {
            OrderTriggersHandler.handlerAfterDelete(Trigger.old);}}}
    
    catch(exception ex){
        system.debug(ex.getMessage());
    }
}