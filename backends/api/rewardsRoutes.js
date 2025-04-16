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

router.post("/add_rewards", upload.single("image"), async (req, res) => {
    try {
        const { reward_name, description, exchange_point, quantity } = req.body;
        const imagePath = req.file ? req.file.path : null;

        if (!reward_name || !description || !exchange_point || !quantity) {
            return res.status(400).json({
                success: false,
                message: "Missing required fields (reward_name, description, exchange_point, quantity)"
            });
        }
        const [result] = await db.query(
            "INSERT INTO rewards(reward_name, description, image_path, exchange_point, quantity) VALUES(?,?,?,?,?)",
            [reward_name, description, imagePath, exchange_point, quantity]

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
router.put("/update_reward/:id", upload.single("image"), async (req, res) => {
    try {
        const reward_id = req.params.id;
        const { reward_name, description, exchange_point, quantity } = req.body;
        const imagePath = req.file ? req.file.path : null;
        let values

        values = [reward_name, description, exchange_point, imagePath, quantity, reward_id];
        const [result] = await db.query(
            "UPDATE rewards SET reward_name = ?, description = ?, exchange_point = ?, image_path = ? , quantity = ? WHERE reward_id = ?", values
        );
        console.log("body:", req.body);
        console.log("file:", req.file);

        res.status(200).json({
            success: true,
            message: "update rewards successfully",
            result: result
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
router.get("/get_rewards", async (req, res) => {
    try {
        const [result] = await db.query("SELECT * FROM rewards ORDER BY reward_id DESC")
        res.status(200).json({
            success: true,
            message: "Get all rewards",
            data: result
        })
    } catch (error) {
        console.error("Database Error:", error);
        res.status(500).json({
            success: false,
            message: "Error Get Rewards",
        });
    }
})
router.post("/exchange_reward/:reward_id", async (req, res) => {
    const reward_id = req.params.reward_id;
    const { user_id } = req.body;
    if (!user_id || !reward_id) {
        return res.status(400).json({ message: 'Missing user_id or reward_id' });
    } try {
        const [rewardRows] = await db.query('SELECT exchange_point FROM rewards WHERE reward_id = ?', [reward_id]);
        if (rewardRows.length === 0) {
            return res.status(404).json({ message: 'Reward not found' });
        }
        const pointCost = rewardRows[0].exchange_point;
        const [userRows] = await db.query('SELECT total_point FROM userAccount WHERE user_id = ?', [user_id]);

        const currentPoints = userRows[0].total_point;
        if (currentPoints < pointCost) {
            return res.status(400).json({
                success: false,
                message: 'Not enough points to exchange reward',

            });
        }
        const [result] = await db.query(
            'INSERT INTO user_exchange (reward_id, user_id) VALUES (?, ?)',
            [reward_id, user_id]
        );
        await db.query(
            'UPDATE userAccount SET total_point = total_point - ? WHERE user_id = ?',
            [pointCost, user_id]
        );
        return res.status(201).json({ success: true, message: 'Reward exchanged successfully', data: result[0] });

    } catch (err) {
        console.error(err);
        return res.status(500).json({ message: 'Server error during exchange' });
    }
});

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
        res.status(500).json({
            success: false,
            message: "Error delete Rewards",
        });
    }
})
router.get('/reward_history/:user_id', async (req, res) => {
    const userId = req.params.user_id;

    try {
        const [result] = await db.query(`
        SELECT 
          UE.exchange_id, 
          UA.user_id,
          CONCAT(UA.firstname, ' ', UA.lastname) AS fullname,
          RW.reward_id,
          RW.reward_name,
          RW.exchange_point,
          RW.image_path,
          UE.created_at AS exchange_on
        FROM user_exchange UE
        JOIN userAccount UA ON UE.user_id = UA.user_id
        JOIN rewards RW ON UE.reward_id = RW.reward_id
        WHERE UA.user_id = ?
        ORDER BY UE.created_at DESC
      `, [userId]);

        res.status(200).json({ success: true, data: result });
    } catch (error) {
        console.error('Error fetching reward history:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

module.exports = router;