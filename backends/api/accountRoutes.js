const express = require('express');
const multer = require('multer');
const bcrypt = require('bcrypt');
const path = require('path');
const db = require('../dbConnection');
const { error } = require('console');
const { route } = require('./rewardsRoutes');
const router = express.Router();
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, "uploads/");
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + path.extname(file.originalname));
    },
});
const upload = multer({
    storage
});

router.post("/register", async (req, res) => {
    try {
        const { firstname, lastname, email, password, address, tel_number } = req.body;

        if (!firstname || !lastname || !email || !password || !address || !tel_number) {
            return res.status(400).json({ error: "Missing required fields" });
        }

        const [checkUser] = await db.query("SELECT * FROM userAccount WHERE email = ?", [email]);
        if (checkUser.length > 0) {
            return res.status(409).json({ error: "Email already used" });
        }

        const saltRounds = 10;
        const hashedPassword = await bcrypt.hash(password, saltRounds);

        const [result] = await db.query(
            "INSERT INTO userAccount (firstname, lastname, email, password, address, tel_number) VALUES (?, ?, ?, ?, ?, ?)",
            [firstname, lastname, email, hashedPassword, address, tel_number]
        );

        res.status(201).json({
            message: "User registered successfully",
            userId: result.insertId
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Failed to register user" });
    }
});
router.post("/adminRegis", async (req, res) => {
    try {
        const { admin_email, admin_password } = req.body;

        if (!admin_email || !admin_password) {
            return res.status(400).json({ error: "Missing required fields" });
        }

        const [checkUser] = await db.query("SELECT * FROM userAccount WHERE email = ?", [admin_email]);
        if (checkUser.length > 0) {
            return res.status(409).json({ error: "Email already used" });
        }

        const saltRounds = 10;
        const hashedPassword = await bcrypt.hash(admin_password, saltRounds);

        const [result] = await db.query(
            "INSERT INTO administrator (admin_email, admin_password) VALUES (?, ?)",
            [admin_email, hashedPassword]
        );

        res.status(201).json({
            message: "User registered successfully",
            userId: result.insertId
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Failed to register user" });
    }
});

module.exports = router;