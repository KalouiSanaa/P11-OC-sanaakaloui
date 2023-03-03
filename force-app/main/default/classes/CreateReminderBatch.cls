global class CreateReminderBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext info) {
        return Database.getQueryLocator([
       SELECT OwnerId, (SELECT Id FROM Orders),(SELECT Id FROM Tasks WHERE Subject='Call') FROM Account
    ]);


    }
         global void execute(Database.BatchableContext bc, List<Account> scope) {
        // Create call task for each account in scope
        List<Task> tasks = new List<Task>();
        for(Account a : scope) {
         Boolean shouldCreateTask = true;
            for(Order o : a.Orders) {
                shouldCreateTask = false;
                break;
            }
            for(Task t : a.Tasks) {
                if(t.Subject == 'Call') {
                    shouldCreateTask = false;
                    break;
                }
            }
            
            if(shouldCreateTask) {
            Task t = new Task();
                t.OwnerId = a.OwnerId;
                t.Subject = 'Call';
                t.Status = 'New';
                t.Priority = 'Normal';
               //t.WhoId = a.OwnerId;
                t.WhatId= a.id;
                t.IsReminderSet = true;
                t.ActivityDate = Date.today().addDays(5);
                t.ReminderDateTime = DateTime.now().addDays(5);
                tasks.add(t);
            }
        insert tasks;
        }}
    
    global void finish(Database.BatchableContext bc) {

    }
    

    
}