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
    saveUninitialized: true,
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

app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});