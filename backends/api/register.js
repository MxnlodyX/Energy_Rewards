const express = require('express');
const db = require('../dbConnection');
const router = express.Router();

router.post("/register", async (req, res) => {
    try {
        const { firstname, lastname, email, password, address, tel_number } = req.body;
        const [result] = await db.query("INSERT INTO userAccount (firstname, lastname, email, password, address, tel_number) VALUES (?,?,?,?,?,?)", [firstname, lastname, email, password, address, tel_number]);
        res.status(201).json({
            success: true,
            message: "Register Successfully",
            result: result
        })
    } catch (error) {
        res.status(500).json({
            success: false,
            message: "Register Failed",
            errors: error
        })
    }
});
module.exports = router;