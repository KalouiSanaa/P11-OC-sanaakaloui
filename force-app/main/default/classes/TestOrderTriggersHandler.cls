@isTest

public with sharing class TestOrderTriggersHandler {
   
    @isTest
    static void handlerAfterDeleteWithproductTest(){
        List<Account> acc= TestDataFactory.createAccounts(50);
        List<Order> orders=TestDataFactory.createOrdersForAccounts(acc,1,50,1);
      Test.startTest();
         OrderTriggersHandler.handlerAfterDelete(orders);
        Test.stopTest();
        List<Account> updated = [SELECT Id, Active__c FROM Account];
        for(Account c:updated){
            System.assertEquals(true,c.Active__c);
        }
    }
    @isTest
     static void handlerAfterDeleteWithNoproductTest(){
        List<Account> acc= TestDataFactory.createAccounts(50);
          List<Order> orders=new List<Order>();
      Test.startTest();
          update orders;
         OrderTriggersHandler.handlerAfterDelete(orders);
        Test.stopTest();
        List<Account> updated = [SELECT Id, Active__c FROM Account where Id IN:acc];
        for(Account c:updated){
            System.assertEquals(False,c.Active__c);
        }
    }
      @isTest
    static void handleBeforeUpdateTest(){
         List<Account> acc= TestDataFactory.createAccounts(50);
        List<Order> orders=TestDataFactory.createOrdersForAccounts(acc,1,50,1);
        for(Order o:orders){
            o.Status='Activated';}
        Test.startTest();
              update orders;
        Test.stopTest();
        List<Order> order= [SELECT Id, Status FROM Order WHERE Id IN:orders];
        // Vérification que le statut de la commande est maintenant 'Ordered'
        System.assertEquals('Activated',order[0].Status);
    }
        
        
    
}