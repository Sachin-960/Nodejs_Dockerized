const express = require('express');
const auth = require('basic-auth');

const app = express();

// Get config from environment
const SECRET_MESSAGE = process.env.SECRET_MESSAGE || 'Hello Secret!';
const USERNAME = process.env.USERNAME || 'admin';
const PASSWORD = process.env.PASSWORD || 'password';

app.get('/', (req, res) => {
  res.send('Hello, world!');
});

app.get('/secret', (req, res) => {
  const user = auth(req);
  if (!user || user.name !== USERNAME || user.pass !== PASSWORD) {
    res.setHeader('WWW-Authenticate', 'Basic realm="Access denied"');
    return res.status(401).send('Authentication required.');
  }

  res.send(SECRET_MESSAGE);
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});