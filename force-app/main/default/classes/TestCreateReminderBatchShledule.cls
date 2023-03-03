@isTest
public class TestCreateReminderBatchShledule {
    @isTest
    static void ReminderBatchShleduleTest(){
          // Créer trois comptes 
        List<Account> accounts = DataFactoyTest.createAccounts(3);
Test.startTest();
        
        // Schedule the batch job
        CreateReminderBatchShledule reminderSchedule = new CreateReminderBatchShledule();
        String cron = '0 0 0 * * ?'; // Every day at midnight
        System.schedule('Test Schedule', cron, reminderSchedule);
        
        Test.stopTest();
        
        // Verify that the batch job was scheduled
        List<CronTrigger> cronTriggers = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = 'Test Schedule'];
        System.assertEquals(1, cronTriggers.size(), 'Batch job not scheduled');
        
            }
}