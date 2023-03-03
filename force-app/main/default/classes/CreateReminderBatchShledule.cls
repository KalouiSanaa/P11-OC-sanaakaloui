global class CreateReminderBatchShledule implements Schedulable {
    global void execute(SchedulableContext ctx) {
        try{
            CreateReminderBatch batchTasks =new CreateReminderBatch();
         Database.executeBatch(batchTasks,2);
        }
        catch(exception ex){
            System.debug(ex.getMessage());
       
  
    }
    }}