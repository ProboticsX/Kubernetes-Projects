const express = require('express');

// Initialize Express app
const app = express();
const PORT = 3001;

// GET request to the root URL ('/') - Welcome page
app.get('/', (req, res) => {
  res.send('Welcome Screen!');
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
