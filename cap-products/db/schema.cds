namespace com.logali;

using {
    cuid,
    managed
} from '@sap/cds/common';

define type Name        : String(50);

type Address {
    Street     : String;
    City       : String;
    State      : String(2);
    PostalCode : String(5);
    Country    : String(3);
};

type EmailsAddresses_01 : array of {
    kind  : String;
    email : String;

};


type EmailsAddresses_02 : array of {
    kind  : String;
    email : String;

};

entity Emails {
    email_01 :      EmailsAddresses_01;
    email_02 : many EmailsAddresses_01;
    email_03 : many {
        kind  : String;
        email : String;
    }

};

type Gender             : String enum {
    male;
    female;
}

entity Order {
    clientGender : Gender;
    status       : Integer enum {
        submitted = 1;
        fulfiller = 2;
        shipped   = 3;
        cancel    = -1;
    };
    Priority     : String @assert.range enum {
        high;
        medium;
        low;
    }
};

entity Car {
    key ID                 : UUID;
        name               : String;
        virtual discount_1 : Decimal;
        //        @Core.Computed:false
        virtual discount_2 : Decimal;
}

context materials {

    entity Prueba : cuid, managed {
        key ID               : UUID;
            Name             : localized String; //not null; // default 'NoName';
            Description      : localized String;
            ImageUrl         : String;
            ReleaseDate      : DateTime; // default $now;
            //        creationDate     : Date default current_date;
            DiscontinuedDate : DateTime;
            Price            : Decimal(16, 2);
            Height           : type of Price; //Decimal(16, 2);
            Width            : Decimal(16, 2);
            Depth            : Decimal(16, 2);
            Quantity         : Decimal(16, 2);
            Supplier         : Association to one sales.Suppliers;
            UnitOfMeasure    : Association to UnitOfMeasures;
            Currency         : Association to Currencies;
            DimensionUnit    : Association to DimensionUnits;
            Category         : Association to Categories;


    };

    // entity Products : cuid, managed {
    entity Products {
        key ID               : UUID;
            Name             : localized String; //not null; // default 'NoName';
            Description      : localized String;
            ImageUrl         : String;
            ReleaseDate      : DateTime; // default $now;
            //        creationDate     : Date default current_date;
            DiscontinuedDate : DateTime;
            Price            : Decimal(16, 2);
            Height           : type of Price; //Decimal(16, 2);
            Width            : Decimal(16, 2);
            Depth            : Decimal(16, 2);
            Quantity         : Decimal(16, 2);
            Supplier         : Association to one sales.Suppliers;
            UnitOfMeasure    : Association to UnitOfMeasures;
            Currency         : Association to Currencies;
            DimensionUnit    : Association to DimensionUnits;
            Category         : Association to Categories;
            SalesData        : Association to many sales.SalesData
                                   on SalesData.Product = $self;
            Reviews          : Association to many ProductReview
                                   on Reviews.Product = $self;

    // StockAvailability :   Association to StockAvailability;

    // Supplier_ID      : UUID;
    // ToSupplier       : Association to one Suppliers
    //                        on ToSupplier.ID = Supplier_ID;
    // UnitOfMeasure_Id : String(2);
    // ToUnitOfMeasure  : Association to UnitOfMeasures
    //                        on ToUnitOfMeasure.ID = UnitOfMeasure_Id;

    };

    entity Categories {
        key ID   : String(1);
            Name : localized String;

    };

    entity StockAvailability {
        key ID          : Integer;
            Description : localized String;
            Product     : Association to Products;

    };

    entity Currencies {
        key ID          : String(3);
            Description : localized String;

    };

    entity UnitOfMeasures {
        key ID          : String(2);
            Description : localized String;

    };

    entity DimensionUnits {
        key ID          : String(2);
            Description : localized String;

    };

    entity ProductReview : cuid, managed {
        // key ID      : UUID;
        Name    : String;
        Rating  : Integer;
        Comment : String;
        Product : Association to Products;

    };

    entity SelProducts   as select from Products;
    entity ProjProducts  as projection on Products;

    entity ProjProducts2 as projection on Products {
        *
    };

    entity ProjProducts3 as projection on Products {
        ReleaseDate,
        Name
    };

};

context sales {
    entity Orders : cuid {
        // key ID       : UUID;
        Date     : Date;
        Customer : String;
        Item     : Composition of many OrderItems
                       on Item.Order = $self;
    };

    entity OrderItems : cuid {
        // key ID       : UUID;
        Order    : Association to Orders;
        Product  : Association to materials.Products;
        Quantity : Integer;

    };

    // entity Suppliers : cuid, managed {


    // entity Suppliers : cuid, managed {

    entity Suppliers {
        key ID      : UUID;
            Name    : materials.Products:Name; // type of Products: Name; //String;
            Address : {
                Street     : String;
                City       : String;
                State      : String(2);
                PostalCode : String(5);
                Country    : String(3);
            };
            // Address : Address;
            Street  : String;
            Email   : String;
            Phone   : String;
            Fax     : String;
            Product : Association to many materials.Products
                          on Product.Supplier = $self;
    };

    entity Suppliers_01 {
        key ID      : UUID;
            Name    : String;
            Address : {
                Street     : String;
                City       : String;
                State      : String(2);
                PostalCode : String(5);
                Country    : String(3);
            };
            // Address : Address;
            Email   : String;
            Phone   : String;
            Fax     : String;


    };

    entity Suppliers_02 {
        key ID      : UUID;
            Name    : String;
            Address : {
                Street     : String;
                City       : String;
                State      : String(2);
                PostalCode : String(5);
                Country    : String(3);
            };
            Email   : String;
            Phone   : String;
            Fax     : String;
    // Product : Association to many materials.Products
    //               on Product.Supplier2 = $self;

    };

    entity Months {
        key ID               : String(2);
            Description      : localized String;
            ShortDescription : localized String(3);

    };

    entity SelProducts1 as
        select from materials.Products {
            *
        };

    entity SelProducts2 as
        select from materials.Products {
            Name,
            Price,
            Quantity
        };

    entity SelProducts3 as
        select from materials.Products
        left join materials.ProductReview
            on Products.Name = ProductReview.Name
        {
            ProductReview.Rating,
            Products.Name,
            sum(
                Products.Price
            ) as TotalProce

        }
        group by
            ProductReview.Rating,
            Products.Name
        order by
            ProductReview.Rating;

    entity SalesData : cuid, managed {
        // key ID            : UUID;
        DeliveryDate  : DateTime;
        Revenue       : Decimal(16, 2);
        Product       : Association to materials.Products;
        Currency      : Association to materials.Currencies;
        DeliveryMonth : Association to Months;

    };

}


context reports {
    entity AverageRating as
        select from logali.materials.ProductReview {
            Product.ID  as ProductID,
            avg(Rating) as AverageRating : Decimal(16, 2)

        }
        group by
            Product.ID;

    entity Products      as
        select from logali.materials.Products
        mixin {
            ToStockAvailibilty : Association to logali.materials.StockAvailability
                                     on ToStockAvailibilty.ID = $projection.StockAvailability;
            ToAverageRating    : Association to AverageRating
                                     on ToAverageRating.ProductID = ID;

        }
        into {
            *,
            ToAverageRating.AverageRating as Rating,
            case
                when
                    Quantity >= 8
                then
                    3
                when
                    Quantity > 0
                then
                    2
                else
                    1
            end                           as StockAvailability : Integer, // este stock es el que esta en $projection
            ToStockAvailibilty


        }

}
// entity Course {
//     key ID      : UUID;
//         Student : Association to many StudentCourse
//                       on Student.Course = $self;

// }

// entity Student {
//     key ID     : UUID;
//         Course : Association to many StudentCourse
//                      on Course.Student = $self;

// }

// entity StudentCourse {
//     key ID      : UUID;
//         Student : Association to Student;
//         Course  : Association to Course;

// }

// entity ParaProducts(pName : String)      as
//     select from Products {

//         Name,
//         Price,
//         Quantity

//     }
//     where
//         Name = : pName;


// entity ProjParamProducts(pName : String) as projection on Products where Name = : pName;

// extend Products with {
//    PriceCondition: String(2);
//    PriceDeterminarion: String(3);

// };
