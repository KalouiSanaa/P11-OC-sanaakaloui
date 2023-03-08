global class CreateReminderBatch implements Database.Batchable<sObject> {
    // La méthode Start renvoie un QueryLocator pour le lot à traiter
    global Database.QueryLocator start(Database.BatchableContext info) {
        // Interroger les comptes avec leurs commandes et appeler les tâches
        return Database.getQueryLocator([
            SELECT Id, OwnerId, (SELECT Id FROM Orders),(SELECT Id FROM Tasks WHERE Subject='Call'  And Status = 'Not Started') FROM Account
        ]);
    }

    // La méthode Execute traite chaque lot d'enregistrements renvoyés par la méthode start
    global void execute(Database.BatchableContext bc, List<Account> scope) {
        try{
          CreateReminderBatchClass.processBatchCreateReminder(Scope);
        } catch (exception ex){
            // Capturez toutes les exceptions et enregistrez-les dans le journal de débogage
            system.debug(ex.getMessage());
        }
    }

    // La méthode Finish est appelée une fois tous les lots traités
    global void finish(Database.BatchableContext bc) {

    }
}