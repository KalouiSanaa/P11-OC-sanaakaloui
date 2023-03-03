@isTest
public  class TestCreateReminderBatch {
    private static Integer numOfAccounts =4;
  private static Integer numOfOrders = 1;
  private static Integer orderAmount = 150;
    @isTest
    static void TestCreateReminderBatchWithOrders() {
             // Insérer les données de test
        List<Account> accounts = TestDataFactory.createAccounts(numOfAccounts);
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts, numOfOrders, orderAmount, 1);
      Test.startTest();
        // Run the batch job
        Database.executeBatch(new CreateReminderBatch());
      Test.stopTest();
        
        // Verify that tasks were created for the appropriate accounts
        List<Task> createdTasks = [SELECT Id, WhoId, WhatId FROM Task WHERE Subject = 'Call' AND Status = 'New'];
        Set<Id> expectedAccountIds = new Set<Id>();
        for (Account a : accounts) {
            if (a.Orders.size() == 0 && a.Tasks.size() == 0) {
                expectedAccountIds.add(a.Id);
            }
        }
        for (Task t : createdTasks) {
            System.assertEquals(expectedAccountIds.contains(t.WhatId), true, 'Task created for unexpected account');
        }
    
    }
    @isTest
    static void TestCreateReminderBatchWithNoOrders() {
     // Insérer les données de test
        List<Account> accounts = TestDataFactory.createAccounts(numOfAccounts);
         Test.startTest();
        // Run the batch job
        Database.executeBatch(new CreateReminderBatch());
      Test.stopTest();
         List<Task> createdTasks = [SELECT Id, WhoId, WhatId FROM Task WHERE Subject = 'Call' AND Status = 'New'];
        Set<Id> expectedAccountIds = new Set<Id>();
        for (Account a : accounts) {
                expectedAccountIds.add(a.Id);
            
        }
        for (Task t : createdTasks) {
            System.assertNotEquals(False, expectedAccountIds.contains(t.WhatId), 'Task created for expected account');
        }}
       
    
    
}