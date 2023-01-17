using CatalogService as service from '../../srv/catalog-service';

annotate service.Products with @(

    Capabilities       : {DeleteRestrictions : {
        $Type     : 'Capabilities.DeleteRestrictionsType',
        Deletable : false
    }, },

    UI.HeaderInfo      : {
        TypeName       : '{i18n>Product}',
        TypeNamePlural : '{i18n>Products}',
        ImageUrl       : ImageUrl,
        Title          : {Value : ProductName},
        Description    : {Value : Description}
    },

    UI.SelectionFields : [
        // ToCategory_ID,
        // ToCurrency_ID,
         CategoryId,
         CurrencyId,
        StockAvailability

    ],
    UI.LineItem        : [
        {
            $Type : 'UI.DataField',
            Label : '{i18n>ImageUrl}',
            Value : ImageUrl,
        },
        {
            $Type : 'UI.DataField',
            Label : '{i18n>ProductName}',
            Value : ProductName,
        },
        {
            $Type : 'UI.DataField',
            Label : '{i18n>Description}',
            Value : Description,
        },
        {
            $Type  : 'UI.DataFieldForAnnotation',
            Label  : '{i18n>Supplier}',
            Target : 'Supplier/@Communication.Contact',
        },
        {
            $Type : 'UI.DataField',
            Label : '{i18n>ReleaseDate}',
            Value : ReleaseDate,
        },
        {
            $Type : 'UI.DataField',
            Label : '{i18n>DiscontinuedDate}',
            Value : DiscontinuedDate,
        },
        {
            Label       : '{i18n>StockAvailability}',
            Value       : StockAvailability,
            Criticality : StockAvailability
        },
        {
            // $Type : 'UI.DataField',
            Label  : '{i18n>Rating}',
            $Type  : 'UI.DataFieldForAnnotation',
            Target : '@UI.DataPoint#AverageRating'

        // Value : Rating
        },
        {
            $Type : 'UI.DataField',
            Label : '{i18n>Price}',
            Value : Price
        },
    ]
);

annotate service.Products with {
    CategoryId        @title : 'Categoría';
    CurrencyId        @title : 'Moneda';
    StockAvailability @title : 'Disponibilidad de Stock';
};

annotate service.Products with @(
    UI.FieldGroup #GeneratedGroup1 : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            // {
            //     $Type : 'UI.DataField',
            //     Label : 'ProductName',
            //     Value : ProductName,
            // },
            // {
            //     $Type : 'UI.DataField',
            //     Label : 'Description',
            //     Value : Description,
            // },
            // {
            //     $Type : 'UI.DataField',
            //     Label : 'ImageUrl',
            //     Value : ImageUrl,
            // },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>ReleaseDate}',
                Value : ReleaseDate,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>DiscontinuedDate}',
                Value : DiscontinuedDate,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>Price}',
                Value : Price,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>Height}',
                Value : Height,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>Width}',
                Value : Width,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>Depth}',
                Value : Depth,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>Quantity}',
                Value : Quantity,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>UnitOfMeasure}',
                Value : ToUnitOfMeasure_ID,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>Currency}',
                Value : ToCurrency_ID,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>CategoryId}',
                Value : ToCategory_ID,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>Category}',
                Value : Category,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>DimensionUnitID}',
                Value : ToDimensionUnit_ID,
            },
            // {
            //     //$Type  : 'UI.DataField',
            //     Label  : 'Rating',
            //     //Value  : Rating,
            //     $Type  : 'UI.DataFieldForAnnotation',
            //     Target : '@UI.DataPoint#AverageRating'
            // },
            {
                Label       : '{i18n>StockAvailability} ',
                Value       : StockAvailability,
                Criticality : StockAvailability
            },
        ],
    },
    UI.Facets                      : [
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'GeneratedFacet1',
            Label  : '{i18n>GeneralInformation}',
            Target : '@UI.FieldGroup#GeneratedGroup1',
        },
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'GeneratedFacet2',
            Label  : '{i18n>GeneralInformationCopy}',
            Target : '@UI.FieldGroup#GeneratedGroup1',
        }
    ],
    UI.HeaderFacets                : [{
        $Type  : 'UI.ReferenceFacet',
        Target : '@UI.DataPoint#AverageRating'
    }]
);

annotate service.Products with {
    // Par ala columna ImageUrl
    ImageUrl @(UI.IsImageURL : true)

};


/**
 * Annotations For Search Help
 */
annotate service.Products with {
    // Category
    ToCategory        @(Common : {
        Text      : {
            $value                 : Category,
            ![@UI.TextArrangement] : #TextOnly,
        },
        ValueList : {
            $Type          : 'Common.ValueListType',
            CollectionPath : 'VH_Categories',
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : ToCategory_ID,
                    ValueListProperty : 'Code'
                },
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : ToCategory_ID,
                    ValueListProperty : 'Text'
                }
            ]

        },
    });

    // Currency
    ToCurrency        @(Common : {
        ValueListWithFixedValues : true,
        ValueList                : {
            $Type          : 'Common.ValueListType',
            CollectionPath : 'VH_Currencies',
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : ToCurrency_ID,
                    ValueListProperty : 'Code'
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'Text'
                }
            ]
        },
    });

    StockAvailability @(Common : {
        ValueListWithFixedValues : true,
        ValueList                : {
            $Type          : 'Common.ValueListType',
            CollectionPath : 'StockAvailability',
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : StockAvailability,
                    ValueListProperty : 'ID'
                },
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : StockAvailability,
                    ValueListProperty : 'Description'
                }
            ]
        },
    }

    );


};

/**
 * Annotations For VH_Categories Entity
 */
annotate service.VH_Categories with {
    Code @(
        UI     : {Hidden : true}, // Ocultar la columna
        Common : {Text : {
            $value                 : Text,
            ![@UI.TextArrangement] : #TextOnly,
        }}
    );
    Text @(UI : {HiddenFilter : true}, // Ocultar el filtro
    );

}

/**
 * Annotations For VH_Currencies Entity
 */
annotate service.VH_Currencies with {
    Code @(UI : {HiddenFilter : true});
    Text @(UI : {HiddenFilter : true});

}

/**
 * Annotations For StockAvailability Entity
 */
annotate service.StockAvailability with {

    ID @(Common : {Text : {
        $value                 : Description,
        ![@UI.TextArrangement] : #TextOnly,
    }, });

}

/**
 * Annotations For VH_UnitOfMeasure Entity
 */
annotate service.VH_UnitOfMeasure with {

    ID   @(UI : {HiddenFilter : true});
    Text @(UI : {HiddenFilter : true});

}

/**
 * Annotations For VH_DimensionUnits Entity
 */
annotate service.VH_DimensionUnits with {

    Code @(UI : {HiddenFilter : true});
    Text @(UI : {HiddenFilter : true});

}

/**
 * Target : 'Supplier/@Communication.Contact', el Supplier
 * viene de la entida products del catalog-service.cds
 */

/**
 * Annotations for Supplier Entity
 */

annotate service.Suppliers with @(Communication : {Contact : {
    $Type : 'Communication.ContactType',
    fn    : Name,
    role  : 'Supplier',
    photo : 'sap-icon://supplier',
    email : [{
        type    : #work,
        address : Email
    }],
    tel   : [
        {
            type : #work,
            uri  : Phone
        },
        {
            type : #fax,
            uri  : Fax
        }
    ]
},

});

/**
 * Data Point for Average Rating
 */
annotate service.Products with @(UI.DataPoint #AverageRating : {
    Value         : Rating,
    Title         : '{i18n>Rating}',
    TargetValue   : 5,
    Visualization : #Rating
});
