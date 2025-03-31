require("dotenv").config();
const express = require("express");
const multer = require("multer"); // Added missing import
const path = require("path"); // Added missing import
const cors = require("cors"); // Added missing import
const db = require("./dbConnection"); // Assuming this exports the pool
const rewardAPI = require("./api/rewardsRoutes")
const registerAPI = require("./api/register")
const app = express();
const port = process.env.PORT;

app.use(cors());
app.use(express.json());
app.use("/uploads", express.static("uploads"));
app.use("/api", rewardAPI)
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, "uploads/");
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + path.extname(file.originalname));
    },
});

const upload = multer({ storage });

app.post("/api/add_Behavior", upload.single("image"), async (req, res) => {
    try {
        const { user_id, description, behaviorDate } = req.body;
        const imagePath = req.file ? req.file.path : null;

        if (!user_id || !description || !behaviorDate) {
            return res.status(400).json({
                success: false,
                message: "Missing required fields (user_id, description, behaviorDate)"
            });
        }

        const [result] = await db.query(
            "INSERT INTO behavior_records (user_id, description, behavior_date, image_path) VALUES (?, ?, ?, ?)",
            [user_id, description, behaviorDate, imagePath]
        );

        res.status(201).json({
            success: true,
            message: "Behavior Recorded Successfully",
            behaviorID: result.insertId
        });
    } catch (error) {
        console.error("Database Error:", error);
        res.status(500).json({
            success: false,
            message: "Error saving behavior",
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    }
});

app.delete("/api/del_Behavior/:id", async (req, res) => {
    try {
        const [result] = await db.query(
            "DELETE FROM behavior_records WHERE id = ?",
            [req.params.id]
        );
        res.status(200).json({
            success: true,
            message: "Delete behavior successfully",
            affectedRows: result.affectedRows
        })
    } catch {
        console.error("Database Error:", error);
        res.status(500).json({
            success: false,
            message: "Error saving behavior",
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    }
})
app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});