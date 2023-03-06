/**
 * Cette classe est responsable de la création des données de test pour l'application.
 * Il inclut des méthodes de création d'enregistrements "Compte" et "Commande" à des fins de test.
 * De plus, il crée les enregistrements `Product` et `PricebookEntry` requis pour créer un enregistrement `Order`.
 *
 * @author [kaloui sanaa]
 *
 */

public class TestDataFactory {
      // Cette méthode crée une liste de comptes.
       public static List<Account> createAccounts(Integer nbAccount) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < nbAccount; i++) {

            // Les comptes sont créés en appelant la méthode createAccount et en lui passant le nom 'Test Account ' + i.
            accounts.add(createAccount('Test Account ' + i));
        }

        // The method returns the list of created accounts
        return accounts;
    }

// Cette méthode crée un compte et l'insère dans la base de données.
    public static Account createAccount(String name) {
        // Il prend un argument de chaîne 'name' qui représente le nom du compte à créer.
        Account account = new Account(Name = name);
        insert account;
        return account;
    }
    // Création de commandes pour les comptes crées
    public static List<Order> createOrdersForAccounts(List<Account> accounts, Integer nbOrder, Integer unitPrice, Integer quantity) {
        
    // crée une liste de contrats, les insère dans la base de données et associe chaque contrat à un compte.
         List<Contract> contracts = new List<Contract>();
         List<Order> orders = new List<Order>();
         for (Account account : accounts) {
             Contract contract = new Contract(
                 AccountId=account.id, 
                 Status='Draft',
                 ContractTerm=5
             );
             contracts.add(contract);
 
             for (Integer k = 0; k < nbOrder; k++) {
                 Order order = new Order(
                     AccountId=account.id,
                     Status='Draft',
                     EffectiveDate=Date.today(),
                     Pricebook2Id=Test.getStandardPricebookId()
                     );
                 orders.add(order);
             }
         }
         insert contracts;
         insert orders;

         // Création de Product2, PricebookEntry, OrderItems et activate Orders
         Product2 product = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');

         //crée un produit. 
         insert product;
         PricebookEntry pbe = new PricebookEntry(
             Pricebook2Id = Test.getStandardPricebookId(),
             Product2Id = product.Id,
             UnitPrice = unitPrice,
             IsActive = true
         );
         //Creer PricebookEntry
         insert pbe;

             //crée une liste d'articles de commande,    
         List<OrderItem> items = new List<OrderItem>();
         OrderItem item;

             //associe chaque article de commande à une commande
         for (Order order : orders) {
             item = new OrderItem (
                 OrderId=order.Id,
                 PricebookEntryId=pbe.Id,
                 Quantity=quantity,
                 UnitPrice=unitPrice
             );
             items.add(item);
         }

         //insère les articles de commande dans la base de données.
         insert items;
       
       //renvoie la liste des commandes créées.
         return orders;
     }
 }