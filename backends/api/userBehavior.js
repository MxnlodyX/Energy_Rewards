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
router.post("/add_Behavior/:id", upload.single("image"), async (req, res) => {
    const id = req.params.id
    const { beh_description, create_date, status, total_point } = req.body;
    const user_id = id;
    const imagePath = req.file ? req.file.path : null;
    if(!beh_description || !imagePath){
        res.status(404).json()
    }
    try {
        const [result] = await db.query();
    } catch {

    }
});
