const express = require('express');
const { Pool } = require('pg');
const app = express();
const cors = require('cors');
app.use(cors());

// Database connection config
const pool = new Pool({
  user: process.env.DB_USER || 'postgres',
  host: process.env.DB_HOST || 'localhost',
  database: process.env.DB_NAME || 'testdb',
  password: process.env.DB_PASSWORD || 'password',
  port: 5432,
});

app.get('/api/status', async (req, res) => {
  try {
    const dbRes = await pool.query('SELECT NOW()');
    res.json({ status: 'Backend is UP', dbTime: dbRes.rows[0].now });
  } catch (err) {
    res.status(500).json({ status: 'Backend is UP, but DB is DOWN', error: err.message });
  }
});

app.listen(5000, () => console.log('Backend running on port 5000'));