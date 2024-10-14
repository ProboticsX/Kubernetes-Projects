const express = require('express');
const AWS = require('aws-sdk');
const path = require('path');

const app = express();
const port = 3003;

// Set your AWS region and S3 bucket details
AWS.config.update({ region: 'us-east-1' });
const S3_BUCKET = '4054-shubhams-eks';
const IMAGE_FOLDER = 'images'
const IMAGE_KEY = 'image.jpg';

// Serve the static index.html file
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'images', 'index.html'));
});

// Endpoint to provide the S3 image URL
app.get('/images', (req, res) => {
    const imageUrl = `https://${S3_BUCKET}.s3.amazonaws.com/${IMAGE_FOLDER}/${IMAGE_KEY}`;
    res.send(imageUrl);
});

// Start the server
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
