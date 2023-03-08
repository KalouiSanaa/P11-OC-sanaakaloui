public class CreateReminderBatchClass {
    public static void processBatchCreateReminder(List<Account> acct){
         // Créer une liste pour contenir les nouvelles tâches d'appel
            List<Task> tasks = new List<Task>();

            // Récupérer les IDs des comptes ayant des commandes
            Set<Id> accountIdsWithOrders = new Set<Id>();
            for (Account a : acct) {
                if (a.Orders.size() > 0) {
                    accountIdsWithOrders.add(a.Id);
                }
            }

            // Récupérer les IDs des comptes ayant des tâches d'appel non démarrées
            Set<Id> accountIdsWithNonStartedCallTasks = new Set<Id>();
            for (Account a : acct) {
                for (Task t : a.Tasks) {
                    if (t.Subject == 'Call' && t.Status == 'Not Started') {
                        accountIdsWithNonStartedCallTasks.add(a.Id);
                        break;
                    }
                }
            }

            // Itérer sur les comptes du lot et créer une tâche d'appel pour ceux qui n'en ont pas
            for (Account a : acct) {
                if (!accountIdsWithOrders.contains(a.Id) && !accountIdsWithNonStartedCallTasks.contains(a.Id)) {
                    // Créer une nouvelle tâche d'appel
                    Task t = new Task();
                    t.ownerId=a.ownerId;
                    // t.WhoId = a.Id;
                    t.Subject = 'Call';
                    t.Status = 'Not Started';
                    t.Priority = 'Normal';
                    t.WhatId = a.Id;
                    t.ActivityDate = Date.today().addDays(5);
                    tasks.add(t);
                }
            }

            // Insertion des nouvelles tâches d'appel
            insert tasks;
        
    }
}