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
router.get("/get_behavior", async (req, res) => {

})
router.post("/add_behavior", upload.single('image'), async (req, res) => {
    try {
        const { behavior_description, behavior_date, user_id } = req.body;
        const imagePath = req.file ? req.file.path : null;
        if (!behavior_description || !behavior_date || !imagePath || !user_id) {
            return res.status(400).json({
                success: false,
                message: "Missing required fields (behavior_description, behavior_date, imagePath)"
            });
        }
        const [result] = await db.query(
            "INSERT INTO user_behavior (behavior_description, behavior_date, image_path, user_id) VALUES(?,?,?,?)",
            [behavior_description, behavior_date, imagePath, user_id]
        );

        res.status(201).json({
            success: true,
            message: "Add New Behavior Successfully",
            BehaviorID: result.insertId

        })
    } catch (error) {
        res.status(500).json({
            success: false,
            message: "Error adding behavior",
        });
    }

})
router.put("/edit_behavior", upload.single('image'), async (req, res) => {
    try {
        const { behavior_id, behavior_description, behavior_date, user_id } = req.body;
        let imagePath = req.file ? req.file.path : null;
        if (!behavior_id || !behavior_description || !behavior_date || !user_id) {
            return res.status(400).json({
                success: false,
                message: "Missing required fields (behavior_id, behavior_description, behavior_date, user_id)"
            });
        }

        if (!imagePath) {
            const [existingBehavior] = await db.query(
                "SELECT image_path FROM user_behavior WHERE behavior_id = ?",
                [behavior_id]
            );

            if (existingBehavior.length === 0) {
                return res.status(404).json({
                    success: false,
                    message: "Behavior not found"
                });
            }

            imagePath = existingBehavior[0].image_path;
        }

        let updateQuery = "UPDATE user_behavior SET behavior_description = ?, behavior_date = ?, user_id = ? WHERE behavior_id = ?";
        let params = [behavior_description, behavior_date, user_id, behavior_id];

        if (imagePath) {
            updateQuery = "UPDATE user_behavior SET behavior_description = ?, behavior_date = ?, image_path = ?, user_id = ? WHERE behavior_id = ?";
            params = [behavior_description, behavior_date, imagePath, user_id, behavior_id];
        }

        const [result] = await db.query(updateQuery, params);

        if (result.affectedRows > 0) {
            res.status(200).json({
                success: true,
                message: "Behavior updated successfully",
                behavior_id
            });
        } else {
            res.status(404).json({
                success: false,
                message: "Behavior not found or no changes made"
            });
        }

    } catch (error) {
        console.error(error);
        res.status(500).json({
            success: false,
            message: "Error updating behavior",

        });
    }
});
router.delete("/delete_behavior/:behavior_id", async (req, res) => {
    try {
        const behavior_id = req.params.behavior_id;

        if (!behavior_id) {
            return res.status(400).json({
                success: false,
                message: "Missing required field: behavior_id"
            });
        }
        const [result] = await db.query(
            "DELETE FROM user_behavior WHERE behavior_id = ?",
            [behavior_id]
        );

        res.status(200).json({
            success: true,
            message: "Behavior deleted successfully",
            behavior_id
        });

    } catch (error) {
        res.status(500).json({
            success: false,
            message: "Error deleting behavior"
        });
    }
});

module.exports = router;