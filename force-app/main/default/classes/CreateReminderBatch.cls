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
   // Itérer sur les comptes du lot
        for(Account a : scope) {
   // Vérifier si le compte a des commandes
         Boolean shouldCreateTask = true;
            for(Order o : a.Orders) {
                shouldCreateTask = false;
                break;
            }
            // Vérifie si le compte a des tâches d'appel qui ne sont pas démarrées
            for(Task t : a.Tasks) {
                if(t.Subject == 'Call'  && t.Status == 'Not Started') {
                    shouldCreateTask = false;
                    break;
                }
            }
            
            if(shouldCreateTask) {
            // Si le compte n'a pas de commandes et de tâches d'appel, créer une nouvelle tâche d'appel
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
            // Insertion des nouvelles tâches d'appel
        insert tasks;
        }}
           // Capturez toutes les exceptions et enregistrez-les dans le journal de débogage
             catch(exception ex){
                 system.debug(ex.getMessage());
             }
             }
    
        // La méthode Finish est appelée une fois tous les lots traités
    global void finish(Database.BatchableContext bc) {

    }
    

    
}