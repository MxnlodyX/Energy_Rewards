const express = require('express');
const db = require('../dbConnection');
const router = express.Router();
const multer = require('multer');
const upload = multer();

router.post("/register", upload.none(), async (req, res) => {
    try {
        const { firstname, lastname, email, password, address, tel_number } = req.body;
        if (!email || !password) {
            return res.status(400).json({ error: "Email and password are required!!" });
        }
        if (tel_number && tel_number.length !== 10) {
            return res.status(400).json({ error: "Phone number must be 10 digits!!" });
        }
        if (!firstname || !lastname) {
            return res.status(400).json({
                error: "Firstname and Lastname are require!!"
            });
        }
        const [result] = await db.query(
            "INSERT INTO userAccount (firstname, lastname, email, password, address, tel_number) VALUES (?, ?, ?, ?, ?, ?)",
            [firstname, lastname, email, password, address, tel_number]
        );
        res.status(201).json({ success: true, message: "Register Successfully", userId: result.insertId });
    } catch (error) {
        console.error("SQL Error:", error);
        res.status(500).json({ error: "Database insertion failed" });
    }
});
module.exports = router;