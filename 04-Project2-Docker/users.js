// Import required libraries
const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql2');

// Initialize Express app
const app = express();
const PORT = 3002;

// Middleware for parsing JSON bodies in POST requests
app.use(bodyParser.json());

// MySQL connection configuration
const db = mysql.createConnection({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'temproot',
  password: process.env.DB_PASSWORD || 'temprootpassword',
  database: process.env.DB_NAME || 'tempmydatabase'
});

// Connect to the MySQL database
db.connect((err) => {
  if (err) {
    console.error('Error connecting to MySQL:', err);
    return;
  }
  console.log('Connected to MySQL database.');
});

// GET request to display all data from a specific table
app.get('/users', (req, res) => {
  const sql = 'SELECT * FROM users;'; // Replace 'tasks' with your table name
  db.query(sql, (err, results) => {
    if (err) {
      console.error('Error fetching data:', err);
      res.status(500).json({ error: 'Failed to fetch data' });
      return;
    }
    res.status(200).json(results);
  });
});

// POST request to insert/update data in the table
app.post('/users', (req, res) => {
  const { name, email } = req.body;

  // Insert data into the 'tasks' table (replace with your table and column names)
  const sql = 'INSERT INTO users (name, email) VALUES (?, ?)';
  const values = [name, email || 'pending']; // default status is 'pending'

  db.query(sql, values, (err, result) => {
    if (err) {
      console.error('Error inserting data:', err);
      res.status(500).json({ error: 'Failed to insert data' });
      return;
    }
    res.status(201).json({ message: 'Task created successfully', id: result.insertId });
  });
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
