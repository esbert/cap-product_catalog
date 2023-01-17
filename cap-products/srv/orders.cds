using com.training as training from '../db/training';

service ManageOrders {

    type cancelOrderReturn {
        status  : String enum {
            Succeeded;
            Failed
        };
        message : String;
    };

    // function geClientTaxRate(ClientEmail : String(65)) returns Decimal(4, 2);
    // action   cancelOrder(ClientEmail : String(65))     returns cancelOrderReturn;

    // vicunlando la función y la acción a la entidad
    entity Orders as projection on training.Orders actions {
        function geClientTaxRate(ClientEmail : String(65)) returns Decimal(4, 2);
        action   cancelOrder(ClientEmail : String(65))     returns cancelOrderReturn;

    }

// entity GetOrders   as projection on training.Orders;
// entity CreateOrder as projection on training.Orders;
// entity UpdateOrder as projection on training.Orders;
// entity DeleteOrder as projection on training.Orders;

}
