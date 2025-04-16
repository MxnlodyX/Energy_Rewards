const express = require('express');
const multer = require('multer');
const bcrypt = require('bcrypt');
const path = require('path');
const db = require('../dbConnection');
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

router.post("/register", upload.single("image"), async (req, res) => {
    try {
        const { firstname, lastname, email, password, address, tel_number } = req.body;
        const imagePath = req.file ? req.file.path : null;

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
            "INSERT INTO userAccount (firstname, lastname, email, password, address, tel_number, image_path) VALUES (?, ?, ?, ?, ?, ?, ?)",
            [firstname, lastname, email, hashedPassword, address, tel_number, imagePath]
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
        const {
            admin_firstname,
            admin_lastname,
            admin_email,
            admin_password,
            admin_tel
        } = req.body;

        // Check required fields
        if (!admin_firstname || !admin_lastname || !admin_email || !admin_password) {
            return res.status(400).json({ error: "Missing required fields" });
        }

        // Check for duplicate email
        const [checkAdmin] = await db.query(
            "SELECT * FROM administrator WHERE admin_email = ?",
            [admin_email]
        );

        if (checkAdmin.length > 0) {
            return res.status(409).json({ error: "Email already in use" });
        }

        // Hash the password
        const saltRounds = 10;
        const hashedPassword = await bcrypt.hash(admin_password, saltRounds);

        // Insert new administrator
        const [result] = await db.query(
            `INSERT INTO administrator 
             (admin_firstname, admin_lastname, admin_email, admin_password, admin_tel) 
             VALUES (?, ?, ?, ?, ?)`,
            [admin_firstname, admin_lastname, admin_email, hashedPassword, admin_tel]
        );

        res.status(201).json({
            success: true,
            message: "Administrator registered successfully",
            admin_id: result.insertId
        });

    } catch (error) {
        console.error("Registration error:", error);
        res.status(500).json({ error: "Internal server error" });
    }
});
router.get("/getInfo/:user_id", async (req, res) => {
    try {
        const id = req.params.user_id;
        if (!id) {
            return res.status(400).json({ error: "id not found" });
        }

        const [userInfo] = await db.query("SELECT * FROM userAccount WHERE user_id = ?", [id]);

        if (!userInfo || userInfo.length === 0) {
            return res.status(404).json({ error: "User not found" });
        }

        res.status(200).json({
            message: "User information retrieved successfully",
            data: userInfo[0],
        });


    } catch (error) {
        res.status(500).json({ error: "Failed to get user infomation" });

    }
})
module.exports = router;