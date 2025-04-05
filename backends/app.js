require("dotenv").config();
const express = require("express");
const multer = require("multer");
const path = require("path");
const cors = require("cors");
const db = require("./dbConnection");
const rewardsRoutes = require("./api/rewardsRoutes");
const accountRoutes = require("./api/accountRoutes");

const app = express();
const port = process.env.PORT;

app.use(cors());
app.use("/uploads", express.static("uploads"));

app.use(express.json()); // For JSON data
app.use(express.urlencoded({ extended: true })); // For form data
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, "uploads/");
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + path.extname(file.originalname));
    },
});

const upload = multer({ storage });

app.use("/api", rewardsRoutes);
app.use("/api", accountRoutes);
app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});