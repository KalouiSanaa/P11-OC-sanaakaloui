public class OrderTriggersHandler {
   public static void handleBeforeUpdate(List<Order> newOrders, Map<Id, Order> oldMap) {
       try{
      //Map<Id, Order> oldMap= new Map<Id,Order>();
      List<Order> ordersToUpdate = new List<Order>();
      for (Order o : newOrders) {
          
         if (o.Status == 'Activated' && oldMap.get(o.Id).Status != 'Activated') {
            if (!hasAssociatedProducts(o.Id)) {
               o.addError('L’utilisateur ne peut pas passer le statut de l’order en « Actif » sauf si l’order en question a des produits associés');
            }
              } 
          else {
                   ordersToUpdate.add(o);
                }
         }
       // If all orders have associated products, update them
        if (!ordersToUpdate.isEmpty()) {
            update ordersToUpdate;
        }}
       catch(exception ex){
           system.debug(ex.getMessage());
       }
      }


   public static Boolean hasAssociatedProducts(Id orderId) {
      List<OrderItem> items = [SELECT Id FROM OrderItem WHERE OrderId = :orderId];
      return items.size() > 0;
   }
    
    
    public static void handlerAfterDelete( List<Order> deletedOrders){
     //   List<Order> deletedOrders=new List<Order>();
        try{
        List<Account> accountsToUpdate = [SELECT Id, Active__c, (SELECT Id FROM Orders) FROM Account];
       for (Account a : accountsToUpdate) {
            if (a.Orders.isEmpty()) {
                a.Active__c = False;
           
           }
           else{
               a.Active__c=True;
           }
        }
        update accountsToUpdate;
        }
        catch(exception ex){
            system.debug(ex.getMessage());
            
            }
    }}