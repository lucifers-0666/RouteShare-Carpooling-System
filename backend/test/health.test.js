const test = require('node:test');
const assert = require('node:assert');
const app = require('../src/app');

test('GET /api/health should return 200 and OK status', async () => {
  const server = app.listen(0);
  const port = server.address().port;

  try {
    const res = await fetch(`http://localhost:${port}/api/health`);
    const data = await res.json();

    assert.strictEqual(res.status, 200);
    assert.strictEqual(data.status, 'OK');
    assert.strictEqual(data.service, 'Sahyān Carpooling API Server');
  } finally {
    server.close();
  }
});
