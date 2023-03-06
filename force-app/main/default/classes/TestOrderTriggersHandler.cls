@isTest

public with sharing class TestOrderTriggersHandler {
   
    // Test pour handlerAfterDelete avec des produits
    @isTest
    static void handlerAfterDeleteWithproductTest(){
        // Crée 50 comptes et 50 commandes associées pour chaque compte
        List<Account> acc= TestDataFactory.createAccounts(50);
        List<Order> orders=TestDataFactory.createOrdersForAccounts(acc,1,50,1);
        // Définit le statut de toutes les commandes comme 'Activated'
        for(Order o:orders){
            o.Status='Activated';
        }
        // Démarre le test
        Test.startTest();
        // Appelle la méthode handlerAfterDelete de la classe OrderTriggersHandler
        OrderTriggersHandler.handlerAfterDelete(orders);
        // Arrête le test
        Test.stopTest();
        // Vérifie que le champ Active__c de chaque compte est vrai
        List<Account> updated = [SELECT Id, Active__c FROM Account];
        for(Account c:updated){
            System.assertEquals(true,c.Active__c);
        }
    }
    
    // Test pour handlerAfterDelete sans produits
    @isTest
    static void handlerAfterDeleteWithNoproductTest(){
        // Crée 50 comptes sans aucune commande associée
        List<Account> acc= TestDataFactory.createAccounts(50);
        // Crée une liste de commandes vide
        List<Order> orders=new List<Order>();
        // Démarre le test
        Test.startTest();
        // Met à jour les commandes
        update orders;
        // Appelle la méthode handlerAfterDelete de la classe OrderTriggersHandler
        OrderTriggersHandler.handlerAfterDelete(orders);
        // Arrête le test
        Test.stopTest();
        // Vérifie que le champ Active__c de chaque compte est faux
        List<Account> updated = [SELECT Id, Active__c FROM Account where Id IN:acc];
        for(Account c:updated){
            System.assertEquals(False,c.Active__c);
        }
    }
    
    // Test pour handleBeforeUpdate
    @isTest
    static void handleBeforeUpdateTest(){
        // Crée 50 comptes et 50 commandes associées pour chaque compte
        List<Account> acc= TestDataFactory.createAccounts(50);
        List<Order> orders=TestDataFactory.createOrdersForAccounts(acc,1,50,1);
        // Définit le statut de toutes les commandes comme 'Activated'
        for(Order o:orders){
            o.Status='Activated';
        }
        // Démarre le test
        Test.startTest();
        // Met à jour les commandes
        update orders;
        // Appelle la méthode handleBeforeUpdate de la classe OrderTriggersHandler
        OrderTriggersHandler.handleBeforeUpdate(orders, new Map<Id, Order>([SELECT Id, Status FROM Order WHERE Id IN:orders]));
        // Arrête le test
        Test.stopTest();
        // Vérifie que le statut de la commande est maintenant 'Activated'
        List<Order> order= [SELECT Id, Status FROM Order WHERE Id IN:orders];
        System.assertEquals('Activated',order[0].Status);
    }
}