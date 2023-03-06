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
            // Créer une liste pour contenir les nouvelles tâches d'appel
            List<Task> tasks = new List<Task>();

            // Récupérer les IDs des comptes ayant des commandes
            Set<Id> accountIdsWithOrders = new Set<Id>();
            for (Account a : scope) {
                if (a.Orders.size() > 0) {
                    accountIdsWithOrders.add(a.Id);
                }
            }

            // Récupérer les IDs des comptes ayant des tâches d'appel non démarrées
            Set<Id> accountIdsWithNonStartedCallTasks = new Set<Id>();
            for (Account a : scope) {
                for (Task t : a.Tasks) {
                    if (t.Subject == 'Call' && t.Status == 'Not Started') {
                        accountIdsWithNonStartedCallTasks.add(a.Id);
                        break;
                    }
                }
            }

            // Itérer sur les comptes du lot et créer une tâche d'appel pour ceux qui n'en ont pas
            for (Account a : scope) {
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
        } catch (exception ex){
            // Capturez toutes les exceptions et enregistrez-les dans le journal de débogage
            system.debug(ex.getMessage());
        }
    }

    // La méthode Finish est appelée une fois tous les lots traités
    global void finish(Database.BatchableContext bc) {

    }
}