// import cds from "@sap/cds";
//import { entity } from "@sap/cds";
const cds = require("@sap/cds");
const { status } = require("express/lib/response");
const { Orders } = cds.entities("com.training");

module.exports = (srv) => {

    srv.before("*", (req) => {
        console.log(`Method: ${req.method}`);
        console.log(`Method: ${req.target}`);
    });

    //***************** READ *****************/
    srv.on("READ", "Orders", async (req) => { // asyn con await anonima

        if (req.data.ClientEmail !== undefined) {
            return await SELECT.from`com.training.Orders`.where`ClientEmail = ${req.data.ClientEmail}`;
        }


        return await SELECT.from(Orders); // es la variable de la constante Linea 3 const { Orders }
    });


    srv.after("READ", "Orders", (data) => { // asyn con await anonima

        return data.map((order) => (order.Reviewed = true));

    });


    //***************** CREATE *****************/   

    srv.on("CREATE", "Orders", async (req) => { // asyn con await anonima

        let returnData = await cds
            .transaction(req)
            .run(
                INSERT.into(Orders).entries({
                    ClientEmail: req.data.ClientEmail,
                    FirstName: req.data.FirstName,
                    LastName: req.data.LastName,
                    CreatedOn: req.data.CreatedOn,
                    Reviewed: req.data.Reviewed,
                    Approved: req.data.Approved,
                    Country: '',
                    Status: '',
                })
            )
            .then((resolve, reject) => {
                console.log("Resolve", resolve);
                console.log("Reject", reject);

                if (typeof resolve !== "undefined") {
                    return req.data;
                } else {
                    req.error(409, "Record Not Inserted");
                }
            })
            .catch((err) => {
                console.log(err);
                req.error(err.code, err.message);
            });
        return returnData;
    });

    srv.before("CREATE", "Orders", (req) => {
        req.data.CreatedOn = new Date().toISOString().slice(0, 10);
        return req;
    });

    //***************** UPDATE *****************/ UPDATE(Orders, {KEY1: VAL1, KEY2: VAL2}) 
    srv.on("UPDATE", "Orders", async (req) => {
        let returnData = await cds.transaction(req).run(
            [
                UPDATE(Orders, req.data.ClientEmail).set({
                    FirstName: req.data.FirstName,
                    LastName: req.data.LastName,
                })
            ]
        ).then((resolve, reject) => {
            console.log("Resolve : ", resolve);
            console.log("Reject : ", reject);

            if (resolve[0] == 0) {
                req.error(409, "Record Not Found");
            }

        }).catch((err) => {
            console.log(err);
            req.error(err.code, err.message);
        });
        console.log("Before End", returnData);
        return returnData;
    });

    //***************** DELETE *****************/ 
    srv.on("DELETE", "Orders", async (req) => {
        let returnData = await cds
            .transaction(req)
            .run(
                DELETE.from(Orders).where({
                    ClientEmail: req.data.ClientEmail,
                })

            ).then((resolve, reject) => {
                console.log("Resolve : ", resolve);
                console.log("Reject : ", reject);

                if (resolve !== 1) {
                    req.error(409, "Record Not Found");
                }

            }).catch((err) => {
                console.log(err);
                req.error(err.code, err.message);
            });
        console.log("Before End", returnData);
        return await returnData;
    });

    //***************** FUNCTION *****************/ 
    srv.on("geClientTaxRate", async (req) => {
        // NO server side-effect 
        const { ClientEmail } = req.data; // ClientEmail es el parametro de la funcion get en el service ManageOrders
        const db = srv.transaction(req);

        const result = await db.read(Orders, ["Country_code"]).where({ ClientEmail: ClientEmail }); //ClientEmail despues de los dos punto es la variable de la const

        console.log(result[0]);

        switch (result[0].Country_code) {
            case 'ES':
                return 21.5;
            case 'UK':
                return 24.6;
            default:
                break;
        }

    });

    //***************** ACTION *****************/ 
    srv.on("cancelOrder", async (req) => {
        const { ClientEmail } = req.data;
        const db = srv.transaction(req);

        const resultsRead = await db.read(Orders, ["FirstName", "LastName", "Approved"]).where({ ClientEmail: ClientEmail });

        let returnOrder = {
            status: "",
            message: "",
        };

        console.log(ClientEmail);
        console.log(resultsRead);

        if (resultsRead[0].Approved == false) {
            const resultsUpdate = await db
                .update(Orders).set({
                    Status: 'C'
                }).where({ ClientEmail: ClientEmail });
            returnOrder.status = "Succeeded";
            returnOrder.message = `The Order place by ${resultsRead[0].FirstName} ${resultsRead[0].LastName} was cancel`;

        } else {
            returnOrder.status = "Failed";
            returnOrder.message = `The Order place by ${resultsRead[0].FirstName} ${resultsRead[0].LastName} was NOT canceled because was already approved`;

        }
        console.log("Action cancelOrder executed");
        return returnOrder;

    });
};
