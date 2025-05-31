const express = require('express');
const cors = require('cors')

const app = express();
const port = 3000;

app.use(cors())

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});

app.get('/api', (req, res) => {
  res.json({ message: 'Hello from backend!' });
});

app.listen(port, () => {
  console.log(`Backend listening on port ${port}`);
}); 