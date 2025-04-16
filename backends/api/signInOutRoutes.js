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
router.post("/signOut", (req, res) => {
    req.session.destroy((err) => {
        if (err) {
            return res.status(500).json({ error: "Failed to log out" });
        }
        res.clearCookie('connect.sid'); 
        res.status(200).json({ message: "Logged out successfully" });
    });
});

module.exports = router;