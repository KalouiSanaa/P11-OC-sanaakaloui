global class CreateReminderBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext info) {
        return Database.getQueryLocator([
       SELECT Id, OwnerId, (SELECT Id FROM Orders),(SELECT Id FROM Tasks WHERE Subject='Call'  And Status = 'Not Started') FROM Account
    ]);


    }
         global void execute(Database.BatchableContext bc, List<Account> scope) {
        // Create call task for each account in scope
             try{
        List<Task> tasks = new List<Task>();
        for(Account a : scope) {
         Boolean shouldCreateTask = true;
            for(Order o : a.Orders) {
                shouldCreateTask = false;
                break;
            }
            for(Task t : a.Tasks) {
                if(t.Subject == 'Call'  && t.Status == 'Not Started') {
                    shouldCreateTask = false;
                    break;
                }
            }
            
            if(shouldCreateTask) {
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
        insert tasks;
        }}
             catch(exception ex){
                 system.debug(ex.getMessage());
             }
             }
    
    global void finish(Database.BatchableContext bc) {

    }
    

    
}