const express = require('express');
const bodyParser = require('body-parser');
const path = require('path');
const fs = require('fs');

// Initialize Express App
const app = express();
const PORT = 3000;

// Define the path to the tasks file inside the 'data' folder
const tasksFolderPath = path.join(__dirname, 'data');
const tasksFilePath = path.join(tasksFolderPath, 'tasks.json');

// Helper function to ensure the folder exists
const ensureFolderExists = () => {
  if (!fs.existsSync(tasksFolderPath)) {
    fs.mkdirSync(tasksFolderPath);
  }
};

// Middleware for parsing JSON requests
app.use(bodyParser.json());

// Helper function to read tasks from the file
const readTasksFromFile = () => {
  try {
    ensureFolderExists(); // Ensure the folder exists before reading
    const data = fs.readFileSync(tasksFilePath, 'utf8');
    return JSON.parse(data) || [];
  } catch (err) {
    // If the file doesn't exist or there's an error, return an empty array
    return [];
  }
};

// Helper function to write tasks to the file
const writeTasksToFile = (tasks) => {
  fs.writeFileSync(tasksFilePath, JSON.stringify(tasks, null, 2));
};


// POST request to create a new task
app.post('/tasks', (req, res) => {

  const { title, description, status } = req.body;
  // Read the existing tasks from the file
  let tasks = readTasksFromFile();

  const task = {
    id: tasks.length + 1, // Auto-incrementing ID
    title,
    description,
    status: status || 'pending', // Default status is 'pending'
    createdAt: new Date()
  };

  // Add the new task to the array
  tasks.push(task);

  // Write the updated tasks to the file
  writeTasksToFile(tasks);

  res.status(201).json({ message: 'Task created successfully', task });

});

// GET request to fetch all tasks
app.get('/tasks', (req, res) => {
  const tasks = readTasksFromFile();  
  res.status(200).json(tasks);
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});

