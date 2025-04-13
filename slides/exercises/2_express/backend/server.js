const express = require('express');
const app = express();
const port = 3000;

app.get('/api', (req, res) => {
  res.json({ message: 'Hello from backend!' });
});

app.listen(port, () => {
  console.log(`Backend listening on port ${port}`);
}); 