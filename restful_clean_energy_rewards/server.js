// index.js
const admin = require('firebase-admin');
const express = require('express');
const bcrypt = require('bcrypt'); 
const bodyParser = require('body-parser');
const serviceAccount = require('./config/serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();
const app = express();
app.use(bodyParser.json());
app.post('/verifyToken', async (req, res) => {
  const idToken = req.body.token;
  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    res.status(200).json({ uid: decodedToken.uid });
  } catch (error) {
    console.error('Error verifying token:', error);
    res.status(401).json({ error: 'Invalid token' });
  }
});

app.put('/givePoints', async (req, res) => {
  const { uid, points } = req.body;
  try {
    await db.collection('users').doc(uid).update({
      rewardPoint: admin.firestore.FieldValue.increment(points)
    });

    return res.status(200).json({ message: 'Points updated successfully' });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
});

app.post('/register', async (req, res) => {
  const { fullname, email, password, address, tel } = req.body;

  try {
    const userRecord = await admin.auth().createUser({
      email,
      password,
      displayName: fullname
    });
    await admin.auth().setCustomUserClaims(userRecord.uid, { role: 'user' });

    // ใช้ Transaction เพื่อสร้างเลขรันนิ่ง (userCount) และ Document ผู้ใช้
    await db.runTransaction(async (transaction) => {
      // 4.1) อ้างอิง document counters ใน collection metadata
      const counterRef = db.collection('metadata').doc('counters');
      const counterDoc = await transaction.get(counterRef);

      // 4.2) ถ้าไม่มี counters มาก่อน ให้สร้างใหม่ด้วย userCount = 0
      if (!counterDoc.exists) {
        transaction.set(counterRef, { userCount: 0 });
      }

      // 4.3) ดึงค่า userCount ปัจจุบัน (ถ้าไม่มี ให้ถือเป็น 0)
      const currentCount = counterDoc.exists ? counterDoc.data().userCount : 0;
      // เพิ่มค่า userCount
      const newCount = currentCount + 1;
      // อัปเดตค่า userCount กลับเข้าไปใน counters
      transaction.update(counterRef, { userCount: newCount });

      // 4.4) สร้าง document ใน collection users โดยใช้ UID จาก Firebase Auth
      const userDocRef = db.collection('users').doc(userRecord.uid);
      transaction.set(userDocRef, {
        fullname,
        address,
        tel,
        email,
        createdAt: new Date(),
        role: 'user',
        customUserID: 'UID' + newCount
      });
    });
    return res.status(201).json({
      uid: userRecord.uid,
      fullname : userRecord.displayName,
      message: 'สมัครสมาชิกเรียบร้อยแล้ว'
    });
  } catch (error) {
    return res.status(400).json({ error: error.message });
  }
});

// 5) เริ่มต้นเซิร์ฟเวอร์
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
