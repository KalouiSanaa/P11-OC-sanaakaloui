@isTest
public class TestCreateReminderBatchShledule {
  @isTest
    static void ReminderBatchShleduleTest(){
        // Créer un compte 
        List<Account> accounts = TestDataFactory.createAccounts(80);
        List<Order> orders=TestDataFactory.createOrdersForAccounts(accounts,1,100,1);
        
        Test.startTest();
        CreateReminderBatchShledule.scheduleJob();
        Test.stopTest();
        
        // Vérifiez que la planification s'est effectuée correctement
        List<CronTrigger> jobList = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE CronJobDetail.Name = 'Create Reminder Batch'];
        System.assertEquals(1, jobList.size(), 'Expecting one job to be scheduled');
        
        // Vérifiez que la planification est correcte
        String expectedCron = '0 0 23 ? * MON';
        System.assertEquals(expectedCron, jobList[0].CronExpression, 'Cron expression should match');
    }
        
        
        
 
       
    }