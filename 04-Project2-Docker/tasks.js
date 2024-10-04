const express = require('express');
const bodyParser = require('body-parser');

// Initialize Express App
const app = express();
const PORT = 3000;

// Middleware for parsing JSON requests
app.use(bodyParser.json());

// In-memory array to store tasks
let tasks = [];

// POST request to create a new task
app.post('/tasks', (req, res) => {
  const { title, description, status } = req.body;
  const task = {
    id: tasks.length + 1, // Auto-incrementing ID
    title,
    description,
    status: status || 'pending', // Default status is 'pending'
    createdAt: new Date()
  };

  tasks.push(task);
  res.status(201).json({ message: 'Task created successfully', task });
});

// GET request to fetch all tasks
app.get('/tasks', (req, res) => {
  res.status(200).json(tasks);
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
