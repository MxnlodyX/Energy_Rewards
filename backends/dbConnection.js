require('dotenv').config();
const mysql = require("mysql2");
const fs = require('fs');
const dotenv = require('dotenv');

const dbConnection = mysql.createConnection({
    host : process.env.DB_HOST,
    user : process.env.DB_USER,
    password : process.env.DB_PASSWORD,
    database : process.env.DB_NAME,
    ssl: {
        ca: fs.readFileSync(process.env.CA)
    }
})

dbConnection.connect(err =>{
    if(err){
        console.log("Error Connection to Database: ",err);
        return;
    }
    console.log("Connecting to Database");
});

module.exports = dbConnection;