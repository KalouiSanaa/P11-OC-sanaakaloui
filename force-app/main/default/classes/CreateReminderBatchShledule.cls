global class CreateReminderBatchShledule implements Schedulable {
    
    // Cette méthode est appelée par le planificateur pour exécuter la tâche planifiée
    global void execute(SchedulableContext ctx) {
        try {
            // Créez une instance de la classe CreateReminderBatch
            CreateReminderBatch batchTasks = new CreateReminderBatch();
            
            // Exécutez la tâche en tant que batch
            Database.executeBatch(batchTasks);
             
        }
        catch (Exception ex) {
            // En cas d'erreur, afficher le message d'erreur dans la console de débogage
            System.debug(ex.getMessage());
        } 
        
    }
    
     // Planifier le lot pour s'exécuter tous les lundis du mois à 23 heures
    public static void scheduleJob() {
        String sch = '0 0 23 ? * MON';
        System.schedule('Create Reminder Batch', sch, new CreateReminderBatchShledule());
    }
}