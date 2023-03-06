@isTest
public class TestCreateReminderBatchShledule {
     @isTest
    static void ReminderBatchShleduleTest(){
        // Créer un compte 
        List<Account> accounts = TestDataFactory.createAccounts(1);
        List<Order> orders=TestDataFactory.createOrdersForAccounts(accounts,1,100,1);
        
        Test.startTest();
        // Planifier le lot d'exécution
        CreateReminderBatchShledule reminderSchedule = new CreateReminderBatchShledule();
        // Planifier le lot pour s'exécuter tous les lundis du mois à 22 heures
        String cron =  '0 0 23 ? * MON';
        System.schedule('Test Schedule', cron, reminderSchedule);
        Test.stopTest();
       
        // Vérifier qu'aucune tâche n'a été créée
        List<Task> tasks = [SELECT Id, Subject FROM Task WHERE Subject = 'Call' AND Id =:accounts[0].Id];
        System.assertEquals(0, tasks.size());
    }            
}
