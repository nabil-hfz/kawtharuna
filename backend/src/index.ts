import initConfig from "./config/index";
initConfig();

import { options } from "./config/swagger.config";

import { initializeDb } from "./db";
initializeDb();

import { Express } from "express";
import * as express from "express";
import { interceptors } from "./interceptors";
import { HttpServer } from "./controllers";
import { CONTROLLERS } from "./controllers/controllers";
import * as cors from "cors";
import { log } from "./utils/logger";
import * as bodyParser from "body-parser";
import * as timeout from "connect-timeout";

import * as swaggerJsdoc from 'swagger-jsdoc';
import * as swaggerUi from 'swagger-ui-express';
import { logRequests } from "./middlewares/logging.middleware";

const swaggerSpec = swaggerJsdoc(options);

const app: Express = express();
app.use(logRequests);

app.use(timeout(1000 * 60 * 3))

// Automatically allow cross-origin requests
app.use(cors({ origin: true }));
// app.use(bodyParser.text({ limit: '1024mb' }))
// app.use(bodyParser.raw({ limit: '1024mb' }))
const maxFileSize = 1024 * 1024 * 1024 * 5;
app.use(bodyParser.json({ limit: maxFileSize }))
app.use(bodyParser.urlencoded({ limit: maxFileSize, extended: true, parameterLimit: maxFileSize }))

interceptors.forEach((interceptor) => {
  app.use(interceptor);
})

const httpServer = new HttpServer(app);
CONTROLLERS.forEach((controller) => {
  controller.initialize(httpServer);
});

// app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

app._router.use('/api-docs', swaggerUi.serve);
app._router.get('/api-docs', swaggerUi.setup(swaggerSpec));
// app.router.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));
// const swaggerSpec = swaggerJSDoc(options);

app.use('/api-docs2', swaggerUi.serve, swaggerUi.setup(swaggerSpec));


app.get('/', (req, res) => {
  res.status(200).send('Hellow world!');
});
app.get('/health', (req, res) => {
  res.status(200).send('Health: OK');
});

// Listen to the App Engine-specified port, or 8080 otherwise
const PORT = process.env.PORT || 8085;
app.listen(PORT, () => {
  log(`Server listening on port http://localhost:${PORT}...`);
});
// https://www.youtube.com/watch?v=CqY2kYJQoK0

// https://www.youtube.com/watch?v=2Ti6r34odOw
// https://www.youtube.com/watch?v=0YTs40kvnW0&list=PLjl2dJMjkDjkBIKd_S9YeBMsT92L8KD4m&index=11
// https://www.youtube.com/watch?v=S45jZCvd2M8&t=43s