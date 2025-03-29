require('dotenv').config();
const express = require("express");
const db = require('./dbConnection');
const app = express();
const port = process.env.PORT;

app.listen(port,()=>{
    console.log(`Server running on Port ${port}`);
});