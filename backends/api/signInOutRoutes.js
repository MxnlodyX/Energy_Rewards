require("dotenv").config();
const express = require('express');
const session = require('express-session');
const bcrypt = require('bcrypt');
const db = require('../dbConnection');
const router = express.Router();
const moment = require('moment-timezone');

const app = express();
app.use(express.json());


router.post("/userLogin", async (req, res) => {
    const { email, password } = req.body;
    if (!email || !password) {
        return res.status(400).json({ error: "Please provide email and password" });
    }
    try {
        const [user] = await db.query("SELECT * from userAccount WHERE email = ?", [email]);
        if (user.length === 0) {
            return res.status(401).json({ error: "Invalid email or passowrd" });
        }
        const isMatch = await bcrypt.compare(password, user[0].password);
        if (!isMatch) {
            return res.status(401).json({ error: "Invalid email or password" });
        }
        req.session.user_id = user[0].user_id;
        req.session.email = user[0].email;
        const thailandTime = moment().tz("Asia/Bangkok").format('YYYY-MM-DD HH:mm:ss');
        const sessionExpireTime = moment(req.session.cookie.expires).tz("Asia/Bangkok").format('YYYY-MM-DD HH:mm:ss');

        res.status(200).json({
            success: true,
            message: "Login successful",
            user_id: req.session.user_id,
            email: req.session.email,
            login_time: thailandTime,
            sessionExpireTime: sessionExpireTime
        });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "Failed to login" });
    }
})
router.post("/adminLogin", async (req, res) => {
    const { admin_email, admin_password } = req.body;

    if (!admin_email || !admin_password) {
        return res.status(400).json({ error: "Please provide email and password" });
    }

    try {
        const [admin] = await db.query("SELECT * FROM administrator WHERE admin_email = ?", [admin_email]);

        if (admin.length === 0) {
            return res.status(401).json({ error: "Invalid email or password" });
        }

        const isMatch = await bcrypt.compare(admin_password, admin[0].admin_password);
        if (!isMatch) {
            return res.status(401).json({ error: "Invalid email or password" });
        }

        // Save admin session
        req.session.admin_id = admin[0].admin_id;
        req.session.admin_email = admin[0].admin_email;

        const thailandTime = moment().tz("Asia/Bangkok").format('YYYY-MM-DD HH:mm:ss');
        const sessionExpireTime = moment(req.session.cookie.expires).tz("Asia/Bangkok").format('YYYY-MM-DD HH:mm:ss');

        res.status(200).json({
            success: true,
            message: "Login successful",
            admin_id: req.session.admin_id,
            admin_email: req.session.admin_email,
            login_time: thailandTime,
            session_expire_time: sessionExpireTime
        });

    } catch (err) {
        console.error("Admin login error:", err);
        res.status(500).json({ error: "Failed to login" });
    }
});
router.post("/signOut", (req, res) => {
    const logoutTime = moment().tz("Asia/Bangkok").format('YYYY-MM-DD HH:mm:ss');
    req.session.destroy((err) => {
        if (err) {
            return res.status(500).json({ error: "Failed to log out" });
        }
        res.clearCookie('connect.sid');
        res.status(200).json({ success: true, message: "Logged out successfully", logoutTime });
    });
});
router.get("/checkSession", (req, res) => {
    if (req.session.admin_id || req.session.user_id) {
        return res.status(200).json({ login: true, session: req.session });
    }
    return res.status(401).json({ login: false });
});

module.exports = router;