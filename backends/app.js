require("dotenv").config();
const express = require("express");
const multer = require("multer");
const path = require("path");
const cors = require("cors");
const session = require('express-session');

const db = require("./dbConnection");
const rewardsRoutes = require("./api/rewardsRoutes");
const accountRoutes = require("./api/accountRoutes");
const behaviorRoutes = require("./api/behaviorRoutes");
const signInOutRoutes = require("./api/signInOutRoutes");

const app = express();
const port = process.env.PORT;

app.use(cors());
app.use("/uploads", express.static("uploads"));
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, "uploads/");
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + path.extname(file.originalname));
    },
});

const upload = multer({ storage });
app.use(session({
    secret: process.env.SECRET,
    resave: false,
    saveUninitialized: false,
    cookie: {
        httpOnly: true,
        secure: false,
        maxAge: 1000 * 60 * 60,
    }
}));

app.use("/api", rewardsRoutes);
app.use("/api", accountRoutes);
app.use("/api", behaviorRoutes);
app.use("/api", signInOutRoutes);
app.get('/admin_dashboard_stats', async (req, res) => {
    try {
        const [rewardRows] = await db.query("SELECT COUNT(*) AS total_energy_rewards FROM rewards");
        const [behaviorRows] = await db.query("SELECT COUNT(*) AS total_user_behavior FROM user_behavior");
        const [userRows] = await db.query("SELECT COUNT(*) AS total_user_account FROM userAccount");

        const stats = {
            total_energy_rewards: rewardRows[0].total_energy_rewards,
            total_user_behavior: behaviorRows[0].total_user_behavior,
            total_user_account: userRows[0].total_user_account,
        };

        res.status(200).json(stats);
    } catch (err) {
        console.error("Dashboard stats error:", err);
        res.status(500).json({ message: "Failed to load dashboard stats" });
    }
});

app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});