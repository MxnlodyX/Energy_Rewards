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
router.get("/get_behavior/:user_id", async (req, res) => {
    const user_id = req.params.user_id;
    try {
        const [result] = await db.query(`
        SELECT 
            ub.behavior_id AS behavior_id,
            ub.behavior_description,
            ub.behavior_date,
            ub.image_path,
            ub.behavior_status,
            ub.total_points,
            ua.user_id AS user_id
        FROM user_behavior ub
        JOIN userAccount ua ON ub.user_id = ua.user_id
        WHERE ub.user_id = ?
        ORDER BY ub.behavior_date DESC;
        `, [user_id]);

        res.status(200).json({
            success: true,
            data: result
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: "Error get behavior"
        });
    }
});
router.get("/get_behavior_id/:behavior_id", async (req, res) => {
    try {
        const behavior_id = req.params.behavior_id;
        const [result] = await db.query(`SELECT * from user_behavior WHERE behavior_id = ?`, [behavior_id]);
        res.status(200).json({
            success: true,
            data: result[0]
        })
    } catch (error) {
        res.status(500).json({
            success: false,
            message: "Error get behavior"
        });
    }
});
router.post('/add_behavior', upload.single('image'), async (req, res) => {
    try {
        const { behavior_description, behavior_date, user_id } = req.body;
        const imagePath = req.file ? req.file.path.replace(/\\/g, '/') : null;

        if (!behavior_description || !behavior_date || !user_id || !imagePath) {
            return res.status(400).json({
                success: false,
                message: 'Missing required fields'
            });
        }

        const query = `
            INSERT INTO user_behavior 
            (behavior_description, behavior_date, user_id, image_path) 
            VALUES (?, ?, ?, ?)
        `;
        const [result] = await db.query(query, [
            behavior_description,
            behavior_date,
            user_id,
            imagePath
        ]);

        res.status(201).json({
            success: true,
            message: 'Behavior added successfully',
            data: {
                behavior_id: result.insertId,
                behavior_description,
                behavior_date,
                user_id,
                image_path: imagePath
            }
        });

    } catch (error) {
        console.error('Error adding behavior:', error);
        res.status(500).json({
            success: false,
            message: 'Server error. Failed to add behavior.',
            error: error.message
        });
    }
});

router.put("/edit_behavior/:behavior_id", upload.single('image'), async (req, res) => {
    try {
        const { behavior_description, behavior_date } = req.body;
        const behavior_id = req.params.behavior_id;
        const imagePath = req.file ? req.file.path : null;
        if (!behavior_id || !behavior_description || !behavior_date || !imagePath) {
            return res.status(400).json({
                success: false,
                message: "Missing required fields (behavior_id, behavior_description, behavior_date, image)"
            });
        }
        const updateQuery = `
            UPDATE user_behavior
            SET behavior_description = ?, behavior_date = ?, image_path = ?
            WHERE behavior_id = ?
        `;
        const params = [behavior_description, behavior_date, imagePath, behavior_id];
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

router.get("/get_all_behavior", async (req, res) => {
    try {
        const [result] = await db.query(`SELECT * from user_behavior WHERE behavior_status = "pending"`);
        res.status(200).json({
            success: true,
            data: result
        })
    } catch (error) {
        res.status(500).json({
            success: false,
            message: "Error get behavior"
        });
    }
});
router.put("/verify_behavior/:behavior_id", async (req, res) => {
    try {
        const { behavior_id } = req.params;
        const { total_point, behavior_status } = req.body;
        if (!total_point || !behavior_status) {
            return res.status(400).json({ message: "Missing required fields" });
        }
        const updateBehaviorQuery = `
            UPDATE user_behavior
            SET total_points = ?, behavior_status = ?
            WHERE behavior_id = ?
        `;
        const [behaviorResult] = await db.query(updateBehaviorQuery, [total_point, behavior_status, behavior_id]);
        if (behaviorResult.affectedRows === 0) {
            return res.status(404).json({ message: "Behavior not found" });
        }
        const getUserIdQuery = `SELECT user_id FROM user_behavior WHERE behavior_id = ? `;
        const [userRows] = await db.query(getUserIdQuery, [behavior_id]);
        const userId = userRows[0].user_id;
        const updateUserScoreQuery = `
            UPDATE userAccount
            SET total_point = total_point + ?
            WHERE user_id = ?
        `;
        await db.query(updateUserScoreQuery, [total_point, userId]);
        res.status(200).json({
            success: true,
            message: "Behavior and user score updated successfully",
            data: behaviorResult
        });
    } catch (error) {
        console.error("Error updating behavior and user score:", error);
        res.status(500).json({
            success: false,
            message: "Internal Server Error"
        });
    }
});


module.exports = router;