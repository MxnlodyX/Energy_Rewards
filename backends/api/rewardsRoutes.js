const express = require('express');
const multer = require('multer');
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
router.put("/update_reward/:id", upload.single("image"), async (req, res) => {
    try {
        const reward_id = req.params.id;
        const { reward_name, description, exchange_point } = req.body;
        const imagePath = req.file ? req.file.path : null;
        let values
        if (imagePath) {
            values = [reward_name, description, exchange_point, imagePath, reward_id];
            const [result] = await db.query(
                "UPDATE rewards SET reward_name = ?, description = ?, exchange_point = ?, image_path = ? WHERE reward_id = ?",
                [reward_name, description, exchange_point, imagePath, reward_id]
            );
        } else {
            values = [reward_name, description, exchange_point, reward_id];
            const [result] = await db.query(
                "UPDATE rewards SET reward_name = ?, description = ?, exchange_point = ? WHERE reward_id = ?",
                [reward_name, description, exchange_point, reward_id]
            );
        }

        res.status(200).json({
            success: true,
            message: "update rewards successfully",
        })

    } catch (error) {
        console.error("Database Error:", error);
        res.status(500).json({
            success: false,
            message: "Error Update Rewards",
            error: error.message
        });
    }
})
router.post("/add_rewards", upload.single("image"), async (req, res) => {
    try {
        const { reward_name, description, exchange_point } = req.body;
        const imagePath = req.file ? req.file.path : null;
        if (!reward_name || !description || !exchange_point) {
            return res.status(400).json({
                success: false,
                message: "Missing required fields (reward_name, description, exchange_point)"
            });
        }
        const [result] = await db.query(
            "INSERT INTO rewards(reward_name, description, image_path, exchange_point) VALUES(?,?,?,?)",
            [reward_name, description, imagePath, exchange_point]

        );
        res.status(201).json({
            success: true,
            message: "Add new Rewards Successfully",
            RewardID: result.insertId

        })
    } catch (error) {
        console.error("Database Error:", error);
        res.status(500).json({
            success: false,
            message: "Error adding Reward",
            error: error.message
        });
    }
});
router.get("/get_rewards", async (req, res) => {
    try {
        const [result] = await db.query("SELECT * FROM rewards")
        res.status(201).json({
            success: true,
            message: "Get all rewards",
            data: result
        })
    } catch (error) {
        console.error("Database Error:", error);
        res.status(500).json({
            success: false,
            message: "Error Get Rewards",
            error: error.message
        });
    }
})

router.delete("/delete_reward/:id", async (req, res) => {
    try {
        const [result] = await db.query("DELETE FROM rewards WHERE reward_id = ?",
            [req.params.id]
        );
        res.status(200).json({
            success: true,
            message: "delete rewards successfully",
            affectedRows: result.affectedRows
        })
    } catch {
        console.error("Database Error:", error);
        res.status(500).json({
            success: false,
            message: "Error delete Rewards",
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    }
})
module.exports = router;