const cds = require("@sap/cds");
// al instalar npm i cors se crea un dependencia en el package.json y luego se llama  "cors": "^2.8.5"

const cors = require("cors");
const adapterProxy = require("@sap/cds-odata-v2-adapter-proxy");

cds.on("bootstrap", (app) => {
    app.use(adapterProxy());
    app.use(cors());
    app.get("/alive", (_, res) => {
        res.status(200).send("Server is Alive");
    });
});

if (process.env.NODE_ENV !== 'production') {
    const swageer = require("cds-swagger-ui-express");
    // agregar enhament 
    cds.on("bootstrap", (app) => {
        app.use(swageer());
    });

    require("dotenv").config();

}
module.export = cds.server;
