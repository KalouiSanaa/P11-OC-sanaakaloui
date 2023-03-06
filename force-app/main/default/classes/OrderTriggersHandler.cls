public class OrderTriggersHandler {
    // Cette méthode est appelée avant la mise à jour des enregistrements Order
    public static void handleBeforeUpdate(List<Order> newOrders, Map<Id, Order> oldMap) {
        try {
            // On crée une liste pour stocker les Orders qui doivent être mis à jour
            List<Order> ordersToUpdate = new List<Order>();
            
            // On parcourt tous les nouveaux Orders
            for (Order o : newOrders) {
                // Si le nouveau statut est "Activated" et l'ancien statut n'était pas "Activated"
                if (o.Status == 'Activated' && oldMap.get(o.Id).Status != 'Activated') {
                    // On vérifie si l'Order a des produits associés
                    if (!hasAssociatedProducts(o.Id)) {
                        // Si l'Order n'a pas de produits associés, on ajoute une erreur
                        o.addError('L’utilisateur ne peut pas passer le statut de l’order en « Actif » sauf si l’order en question a des produits associés');
                    }
                } else {
                    // Si le statut n'est pas "Activated", on ajoute l'Order à la liste des Orders à mettre à jour
                    ordersToUpdate.add(o);
                }
            }
            
            // Si tous les Orders ont des produits associés, on les met à jour
            if (!ordersToUpdate.isEmpty()) {
                update ordersToUpdate;
            }
        } catch (Exception ex) {
            // En cas d'erreur, on affiche un message de débogage
            system.debug(ex.getMessage());
        }
    }
    
    // Cette méthode vérifie si un Order a des produits associés
    public static Boolean hasAssociatedProducts(Id orderId) {
        List<OrderItem> items = [SELECT Id FROM OrderItem WHERE OrderId = :orderId];
        return items.size() > 0;
    }
    
    // Cette méthode est appelée après la suppression d'un enregistrement Order
    public static void handlerAfterDelete(List<Order> deletedOrders) {
        try {
            // On crée une liste pour stocker les Accounts qui doivent être mis à jour
            List<Account> accountsToUpdate = [SELECT Id, Active__c, (SELECT Id FROM Orders) FROM Account];
            
            // On parcourt tous les Accounts
            for (Account a : accountsToUpdate) {
                // Si l'Account n'a plus d'Orders associés, on désactive l'Account
                if (a.Orders.isEmpty()) {
                    a.Active__c = False;
                } else {
                    // Sinon, on active l'Account
                    a.Active__c = True;
                }
            }
            
            // On met à jour tous les Accounts
            update accountsToUpdate;
        } catch (Exception ex) {
            // En cas d'erreur, on affiche un message de débogage
            system.debug(ex.getMessage());
        }
    }
}