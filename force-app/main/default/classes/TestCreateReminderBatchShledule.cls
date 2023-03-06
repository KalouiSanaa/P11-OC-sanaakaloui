@isTest
public class TestCreateReminderBatchShledule {
    @isTest
    static void ReminderBatchShleduleTest(){
      // Créer trois comptes 
 List<Account> accounts = TestDataFactory.createAccounts(1);
List<Order> orders=TestDataFactory.createOrdersForAccounts(accounts,1,100,1);

          Test.startTest();
     // Schedule the batch job
    CreateReminderBatchShledule reminderSchedule = new CreateReminderBatchShledule();
       // Schedule the batch to run every Monday of the month at 10 PM

    String cron =  '0 0 23 ? * MON';
    System.schedule('Test Schedule', cron, reminderSchedule);
    
          Test.stopTest();
   
    List<Task> tasks = [SELECT Id, Subject FROM Task WHERE Subject = 'Call' AND Id =:accounts[0].Id];
    System.assertEquals(0, tasks.size());
} 
        
}