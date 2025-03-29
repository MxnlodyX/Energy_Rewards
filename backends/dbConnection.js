// dbConnection.js
require('dotenv').config();
const mysql = require('mysql2/promise'); // Note: using promise version
const fs = require('fs');

const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0,
    ssl: {
        ca: fs.readFileSync(process.env.CA)
    }
});

// Test connection
pool.getConnection()
    .then(conn => {
        console.log('Connected to database');
        conn.release();
    })
    .catch(err => {
        console.error('Database connection error:', err);
    });

module.exports = pool;