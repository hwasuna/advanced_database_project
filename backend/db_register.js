const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');

const db = require('./db_connection'); // Connexion à MySQL, fichier séparé

router.post('/', async (req, res) => {
  const { username, firstname, lastname, email, password } = req.body;

  if (!username || !firstname || !lastname || !email || !password) {
    return res.status(400).send({ success: false, message: 'All fields are required.' });
  }

  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    const sql = 'INSERT INTO users (username, firstname, lastname, email, password) VALUES (?, ?, ?, ?, ?)';
    db.query(sql, [username, firstname, lastname, email, hashedPassword], (err) => {
      if (err) {
        if (err.code === 'ER_DUP_ENTRY') {
          return res.status(400).send({ success: false, message: 'Email or username already exists.' });
        }
        console.error('Database error:', err);
        return res.status(500).send({ success: false, message: 'Internal server error.' });
      }
      res.send({ success: true, message: 'Account created successfully!' });
    });
  } catch (err) {
    console.error('Error during signup:', err);
    res.status(500).send({ success: false, message: 'Error during signup process.' });
  }
});

module.exports = router;