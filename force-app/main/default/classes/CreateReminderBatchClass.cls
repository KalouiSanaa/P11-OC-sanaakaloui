public class CreateReminderBatchClass {
    public static void processBatchCreateReminder(List<Account> acct){
         // Créer une liste pour contenir les nouvelles tâches d'appel
            List<Task> tasks = new List<Task>();

        // Pour chaque compte
        for (Account account : acct){
            // Si le compte n'a pas de commandes et pas de tâches 'Call' associées
            if (account.Orders.size() == 0 && account.Tasks.size() == 0) {
                // Création d'une nouvelle tâche 'Call' pour le compte
                    Task t = new Task();
                    t.ownerId= account.ownerId;
                    // t.WhoId = a.Id;
                    t.Subject = 'Call';
                    t.Status = 'Not Started';
                    t.Priority = 'Normal';
                    t.WhatId =  account.Id;
                    t.ActivityDate = Date.today().addDays(5);
                    tasks.add(t);
                    
      
                }
            }

            // Insertion des nouvelles tâches d'appel
            insert tasks;
        System.debug(tasks);
        
    }
}