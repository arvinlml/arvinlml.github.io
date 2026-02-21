# Node.js Interview Questions

Comprehensive interview preparation with practical examples for all levels.

---

## 🟢 **Junior/Beginner Level**

### Node.js Fundamentals

**Q1: What is Node.js and why use it?**

Node.js is a JavaScript runtime built on Chrome's V8 engine that allows running JavaScript on the server-side.

**Advantages:**
- Single language (JavaScript) for front and back-end
- Event-driven, non-blocking I/O
- Great for I/O-heavy applications
- Large npm ecosystem
- Lightweight and scalable

**Q2: Explain the Node.js event loop.**

```javascript
// Event loop phases:
// 1. Timers: Execute setTimeout/setInterval callbacks
// 2. Pending callbacks: Execute deferred I/O callbacks
// 3. Idle, prepare
// 4. Poll: Retrieve new I/O events
// 5. Check: Execute setImmediate callbacks
// 6. Close callbacks

console.log('Start');

setTimeout(() => console.log('setTimeout'), 0);

setImmediate(() => console.log('setImmediate'));

console.log('End');

// Output:
// Start
// End
// setTimeout (runs in timers phase)
// setImmediate (runs in check phase)
```

**Q3: What's the difference between require() and import?**

```javascript
// CommonJS (Node.js default)
const express = require('express');
const { readFile } = require('fs/promises');

module.exports = {
  app,
  config
};

// ES6 Modules (Node.js 12+)
import express from 'express';
import { readFile } from 'fs/promises';

export { app, config };
export default app;

// Differences:
// - require is synchronous, import is asynchronous
// - require loads modules at runtime, import at parse time
// - import has tree-shaking, require doesn't
// - Both work in modern Node.js (use .mjs or package.json "type": "module")
```

**Q4: What are Node.js modules?**

```javascript
// Module 1: math.js
function add(a, b) {
  return a + b;
}

function subtract(a, b) {
  return a - b;
}

module.exports = { add, subtract };

// Module 2: app.js
const { add, subtract } = require('./math');

console.log(add(5, 3));  // 8
console.log(subtract(5, 3));  // 2

// Node.js automatically wraps code:
// (function(exports, require, module, __filename, __dirname) {
//   ... your code ...
// });
```

**Q5: What are global objects in Node.js?**

```javascript
// Global objects available everywhere
console.log(__dirname);  // Current directory path
console.log(__filename);  // Current file path
console.log(process);  // Process object
console.log(global);  // Global object (like window in browser)

// Access command-line arguments
console.log(process.argv);
// node app.js arg1 arg2
// → ['node', '/path/to/app.js', 'arg1', 'arg2']

// Check Node environment
if (process.env.NODE_ENV === 'production') {
  console.log('Running in production');
}

// Process events
process.on('exit', () => console.log('Process exiting'));
process.on('uncaughtException', (err) => console.log('Error:', err));
```

**Q6: Explain callback functions.**

```javascript
// Callback - function passed as argument
function fetchData(id, callback) {
  setTimeout(() => {
    const user = { id, name: 'John' };
    callback(null, user);  // Convention: error first
  }, 1000);
}

// Usage
fetchData(1, (err, user) => {
  if (err) {
    console.error('Error:', err);
  } else {
    console.log('User:', user);
  }
});

// Problem: Callback hell
fetchData(1, (err, user) => {
  fetchData(user.id, (err, data) => {
    fetchData(data.id, (err, moreData) => {
      // Deeply nested - hard to read
    });
  });
});
```

---

## 🟡 **Mid-Level**

### Promises & Async/Await

**Q7: Explain Promises. What are the states?**

```javascript
// Promise states: Pending → Fulfilled/Rejected

const promise = new Promise((resolve, reject) => {
  setTimeout(() => {
    resolve('Success!');  // Fulfills promise
    // reject(new Error('Failed!'));  // Would reject
  }, 1000);
});

promise
  .then(result => console.log(result))
  .catch(error => console.error(error))
  .finally(() => console.log('Done'));

// Promise chain
fetch('/api/user/1')
  .then(res => res.json())
  .then(user => fetch(`/api/posts/${user.id}`))
  .then(res => res.json())
  .then(posts => console.log(posts))
  .catch(err => console.error(err));
```

**Q8: What's the difference between Promises and Async/Await?**

```javascript
// Promises - original approach
function getUser(id) {
  return fetch(`/api/user/${id}`)
    .then(res => res.json())
    .catch(err => console.error(err));
}

// Async/Await - syntactic sugar over Promises
async function getUser(id) {
  try {
    const res = await fetch(`/api/user/${id}`);
    const user = await res.json();
    return user;
  } catch (err) {
    console.error(err);
  }
}

// Same behavior, but async/await is more readable
// Async/await is still Promises under the hood
```

**Q9: Explain async/await with practical example.**

```javascript
// Problem: Sequential async operations
async function getUserWithPosts(userId) {
  try {
    // Sequential - waits for first to complete
    const user = await getUser(userId);
    const posts = await getPosts(userId);
    
    return { user, posts };
  } catch (err) {
    console.error('Error:', err);
  }
}

// Better: Parallel operations
async function getUserWithPostsParallel(userId) {
  try {
    // Run both simultaneously
    const [user, posts] = await Promise.all([
      getUser(userId),
      getPosts(userId)
    ]);
    
    return { user, posts };
  } catch (err) {
    console.error('Error:', err);
  }
}

// Race - return first to complete
const firstResult = await Promise.race([
  fetch('server1'),
  fetch('server2'),
  fetch('server3')
]);
```

**Q10: What's the difference between Promise.all, Promise.race, and Promise.allSettled?**

```javascript
const promises = [
  Promise.resolve('A'),
  Promise.resolve('B'),
  Promise.reject('Error')
];

// Promise.all - fails if any promise rejects
Promise.all(promises)
  .then(results => console.log(results))  // Never runs
  .catch(err => console.log(err));  // Logs 'Error'

// Promise.race - returns first to settle
Promise.race([
  new Promise(r => setTimeout(() => r('A'), 100)),
  new Promise(r => setTimeout(() => r('B'), 50))
])
  .then(result => console.log(result));  // 'B' (fastest)

// Promise.allSettled - waits for all, shows results/errors
Promise.allSettled(promises)
  .then(results => {
    console.log(results);
    // [
    //   { status: 'fulfilled', value: 'A' },
    //   { status: 'fulfilled', value: 'B' },
    //   { status: 'rejected', reason: 'Error' }
    // ]
  });
```

### Error Handling

**Q11: How do you handle errors in Node.js?**

```javascript
// 1. Try/Catch (Async/Await)
async function readFile() {
  try {
    const data = await fs.promises.readFile('file.txt');
    console.log(data);
  } catch (err) {
    console.error('File error:', err);
  }
}

// 2. .catch() (Promises)
fetchData()
  .then(data => processData(data))
  .catch(err => console.error(err));

// 3. Error listeners
process.on('uncaughtException', (err) => {
  console.error('Uncaught exception:', err);
  process.exit(1);  // Exit process
});

process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled rejection:', reason);
});

// 4. Error middleware (Express)
app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: err.message });
});
```

**Q12: What's the difference between throw and reject?**

```javascript
// throw - immediate, stops execution
function throwError() {
  throw new Error('Sync error');  // Stops here
  console.log('Never runs');
}

try {
  throwError();
} catch (err) {
  console.error(err);
}

// reject - promise rejection
function rejectError() {
  return new Promise((resolve, reject) => {
    reject(new Error('Async error'));
  });
}

rejectError()
  .catch(err => console.error(err));

// In async/await, throw becomes rejection
async function throwInAsync() {
  throw new Error('This becomes a rejection');
}

throwInAsync().catch(err => console.error(err));
```

### File System & Streams

**Q13: How do you work with files in Node.js?**

```javascript
const fs = require('fs');
const fsPromises = require('fs').promises;

// Callback (legacy)
fs.readFile('file.txt', 'utf8', (err, data) => {
  if (err) throw err;
  console.log(data);
});

// Promises (modern)
async function readFile() {
  const data = await fsPromises.readFile('file.txt', 'utf8');
  console.log(data);
}

// Write file
await fsPromises.writeFile('file.txt', 'Hello', 'utf8');

// Append to file
await fsPromises.appendFile('file.txt', '\nWorld');

// Delete file
await fsPromises.unlink('file.txt');

// Read directory
const files = await fsPromises.readdir('.');
console.log(files);

// Check if file exists
const exists = fs.existsSync('file.txt');
```

**Q14: What are streams? Why use them?**

```javascript
const fs = require('fs');

// Reading file without streams (entire file in memory)
const data = fs.readFileSync('large-file.txt');  // Slow, memory-heavy

// Using streams (chunks of data)
const stream = fs.createReadStream('large-file.txt', {
  encoding: 'utf8',
  highWaterMark: 16 * 1024  // 16 KB chunks
});

stream.on('data', (chunk) => {
  console.log('Received chunk:', chunk.length);
});

stream.on('end', () => {
  console.log('Stream finished');
});

stream.on('error', (err) => {
  console.error('Stream error:', err);
});

// Pipe - connect streams
fs.createReadStream('input.txt')
  .pipe(fs.createWriteStream('output.txt'));

// Transforming streams
const { Transform } = require('stream');

const uppercase = new Transform({
  transform(chunk, encoding, callback) {
    this.push(chunk.toString().toUpperCase());
    callback();
  }
});

fs.createReadStream('input.txt')
  .pipe(uppercase)
  .pipe(fs.createWriteStream('output.txt'));
```

---

## 🔴 **Senior/Advanced Level**

### Event Emitter

**Q15: Explain EventEmitter. Create a custom emitter.**

```javascript
const EventEmitter = require('events');

// Create custom emitter
class UserService extends EventEmitter {
  createUser(name) {
    const user = { id: Date.now(), name };
    
    // Emit event
    this.emit('user-created', user);
    
    return user;
  }

  deleteUser(id) {
    this.emit('user-deleted', id);
  }
}

// Usage
const userService = new UserService();

// Listen for events
userService.on('user-created', (user) => {
  console.log('User created:', user);
  // Send email notification
  // Update analytics
});

userService.on('user-deleted', (id) => {
  console.log('User deleted:', id);
});

// Listen once
userService.once('user-created', (user) => {
  console.log('First user created:', user);
});

// Create event
userService.createUser('John');

// Remove listener
userService.removeListener('user-created', handler);
userService.removeAllListeners();
```

### Clustering & Child Processes

**Q16: What is clustering and when do you use it?**

```javascript
const cluster = require('cluster');
const http = require('http');
const os = require('os');

if (cluster.isMaster) {
  const numCPUs = os.cpus().length;

  // Fork workers
  for (let i = 0; i < numCPUs; i++) {
    cluster.fork();
  }

  // Handle worker exit
  cluster.on('exit', (worker, code, signal) => {
    console.log(`Worker ${worker.process.pid} died`);
    cluster.fork();  // Restart failed worker
  });
} else {
  // Worker process
  const server = http.createServer((req, res) => {
    res.writeHead(200);
    res.end(`Handled by worker ${process.pid}`);
  });

  server.listen(3000);
  console.log(`Worker ${process.pid} started`);
}

// Run: node app.js
// Creates one process per CPU core
// If one worker crashes, master forks new one
// Load balancer automatically distributes requests
```

**Q17: What are child processes?**

```javascript
const { spawn, exec, execFile, fork } = require('child_process');

// exec - runs shell command, returns output
exec('ls -la', (err, stdout, stderr) => {
  console.log(stdout);
});

// spawn - launches new process, streams data
const ls = spawn('ls', ['-la']);

ls.stdout.on('data', (data) => {
  console.log(data.toString());
});

ls.on('close', (code) => {
  console.log('Process exited with code:', code);
});

// fork - Node.js process (can send messages)
const child = fork('./child.js');

// Send message to child
child.send({ hello: 'world' });

// Receive message from child
child.on('message', (msg) => {
  console.log('Message from child:', msg);
});

// child.js
process.on('message', (msg) => {
  console.log('Message from parent:', msg);
  process.send({ reply: 'Got it!' });
});
```

### Performance & Memory

**Q18: How do you handle memory leaks in Node.js?**

```javascript
// Common memory leak: Keeping references
const cache = [];  // Never cleared!

function handleRequest(id) {
  const data = fetchData(id);
  cache.push(data);  // Grows infinitely
}

// Fix 1: Use WeakMap
const cache = new WeakMap();

// Fix 2: Use LRU Cache
const LRU = require('lru-cache');
const cache = new LRU({ max: 1000 });

function handleRequest(id) {
  const data = fetchData(id);
  cache.set(id, data);
}

// Fix 3: Implement timeout
const cache = new Map();

function handleRequest(id) {
  const data = fetchData(id);
  cache.set(id, data);
  
  setTimeout(() => {
    cache.delete(id);  // Clean up after 1 hour
  }, 60 * 60 * 1000);
}

// Debugging memory:
// node --inspect app.js
// Then use Chrome DevTools memory profiler
```

**Q19: How do you optimize Node.js performance?**

```javascript
// 1. Use async/await, not callbacks
// Cleaner, easier to read, better stack traces

// 2. Use caching
const cache = new Map();
function expensiveOperation(id) {
  if (cache.has(id)) return cache.get(id);
  
  const result = doHeavyCalculation(id);
  cache.set(id, result);
  return result;
}

// 3. Use clustering
// Leverage multiple CPU cores

// 4. Use compression
const compression = require('compression');
app.use(compression());

// 5. Use connection pooling (databases)
const pool = mysql.createPool({
  connectionLimit: 10,
  host: 'localhost',
  user: 'root',
  password: 'password',
  database: 'mydb'
});

// 6. Monitor and profile
// Use: clinic.js, 0x, autocannon
// npm install -g clinic
// clinic doctor -- node app.js

// 7. Use worker threads for CPU-intensive tasks
const { Worker } = require('worker_threads');
const worker = new Worker('./worker.js');
worker.on('message', (result) => {
  console.log('Result:', result);
});
```

### Middleware & Express

**Q20: Explain middleware in Express.**

```javascript
const express = require('express');
const app = express();

// Middleware - function with access to req, res, next
function loggerMiddleware(req, res, next) {
  console.log(`${req.method} ${req.path}`);
  next();  // Pass to next middleware
}

// Use middleware
app.use(loggerMiddleware);

// Built-in middleware
app.use(express.json());  // Parse JSON body
app.use(express.static('public'));  // Serve static files

// Route-specific middleware
app.get('/admin', authenticate, (req, res) => {
  res.send('Admin page');
});

function authenticate(req, res, next) {
  if (req.headers.authorization) {
    next();
  } else {
    res.status(401).send('Unauthorized');
  }
}

// Error handling middleware (4 params)
app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: err.message });
});

// Middleware order matters!
// They run sequentially
```

---

## 🎯 **Tricky Questions**

**Q21: What is "this" context in Node.js?**

```javascript
// Global context
console.log(this);  // {} (module scope, not global object)
console.log(global);  // Global object

// In function
function test() {
  console.log(this);  // undefined in strict mode, global in non-strict
}

// In arrow function
const test = () => {
  console.log(this);  // Inherits from parent scope
};

// In object
const obj = {
  name: 'John',
  greet() {
    console.log(this.name);  // 'John'
  }
};

// Best practice: Use arrow functions for consistent 'this'
```

**Q22: How do you prevent the "Cannot find module" error?**

```javascript
// Problem: Circular dependencies
// a.js
module.exports = require('./b');

// b.js
module.exports = require('./a');  // Circular!

// Solution: Defer requires
// a.js
exports.greet = function() {
  const b = require('./b');
  b.greet();
};

// Solution 2: Use separate initialization
// index.js
const a = require('./a');
const b = require('./b');
a.init(b);
b.init(a);
```

**Q23: What's the difference between process.nextTick() and setImmediate()?**

```javascript
// process.nextTick() - runs after current operation, before I/O
console.log('1');

process.nextTick(() => console.log('2'));

console.log('3');

// Output: 1, 3, 2

// setImmediate() - runs in check phase of event loop
console.log('1');

setImmediate(() => console.log('2'));

console.log('3');

// Output: 1, 3, 2

// In nested callbacks:
setImmediate(() => {
  console.log('immediate 1');
  process.nextTick(() => console.log('nextTick'));
  console.log('immediate 2');
});

// Output:
// immediate 1
// immediate 2
// nextTick (runs before next setImmediate)
```

**Q24: How do you handle large file uploads?**

```javascript
const express = require('express');
const multer = require('multer');
const fs = require('fs');

// Configure storage
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + '-' + file.originalname);
  }
});

const upload = multer({ 
  storage,
  limits: { fileSize: 100 * 1024 * 1024 }  // 100MB
});

// Handle file upload
app.post('/upload', upload.single('file'), (req, res) => {
  res.json({ message: 'File uploaded', file: req.file });
});

// Stream approach for very large files
app.post('/upload-stream', (req, res) => {
  const filename = Date.now() + '-file.dat';
  const stream = fs.createWriteStream(`uploads/${filename}`);

  req.pipe(stream);

  stream.on('finish', () => {
    res.json({ message: 'File uploaded' });
  });

  stream.on('error', (err) => {
    res.status(500).json({ error: err.message });
  });
});
```

**Q25: What's the difference between process.exit() and return?**

```javascript
// return - exits current function
function test() {
  console.log('start');
  return;  // Exits function only
  console.log('never runs');
}

test();
console.log('after function');  // Runs

// process.exit() - terminates entire Node.js process
function test() {
  console.log('start');
  process.exit(0);  // Exits Node.js
  console.log('never runs');
}

test();
console.log('after function');  // Never runs

// Exit codes:
// 0 = success
// 1 = general error
// 2 = misuse of shell command
// 8 = fatal error

// Graceful shutdown
process.on('SIGTERM', async () => {
  console.log('Graceful shutdown');
  await server.close();
  process.exit(0);
});
```

---

## 📚 **Framework & Architecture Questions**

**Q26: When would you use Express vs Fastify vs Koa?**

| Framework | Use Case |
|-----------|----------|
| **Express** | Most popular, mature, largest community |
| **Fastify** | High performance, streaming, needs speed |
| **Koa** | Lightweight, use async/await, built by Express creators |
| **NestJS** | Large enterprise apps, TypeScript, structure |

**Q27: How would you structure a large Node.js project?**

```
project/
├── src/
│   ├── controllers/      # Request handlers
│   ├── services/         # Business logic
│   ├── models/           # Data models
│   ├── routes/           # API routes
│   ├── middleware/       # Custom middleware
│   ├── utils/            # Helper functions
│   ├── config/           # Configuration
│   └── app.js            # Express app setup
├── tests/                # Test files
├── .env                  # Environment variables
├── .env.example          # Example env
├── package.json
├── dockerfile            # Docker configuration
└── README.md
```

---

## ✅ **Final Check Before Interview**

- [ ] Understand event loop thoroughly
- [ ] Know async/await vs Promises vs callbacks
- [ ] Be comfortable with streams
- [ ] Know file system operations
- [ ] Understand middleware pattern
- [ ] Know about clustering and child processes
- [ ] Understand memory management
- [ ] Be familiar with npm ecosystem
- [ ] Know security best practices (helmet, CORS, etc.)
- [ ] Know error handling patterns
- [ ] Have built a few projects
- [ ] Be ready to debug code
- [ ] Know common packages (express, dotenv, joi, etc.)

---

## 🎯 **Pro Tips for Interviews**

1. **Show your process** - Explain your thinking
2. **Ask clarifying questions** - "Production or dev environment?"
3. **Discuss trade-offs** - "This is faster but uses more memory"
4. **Give examples** - Code samples are powerful
5. **Be honest** - "I haven't used that, but I'd learn it quickly"
6. **Stay calm** - Everyone has gaps in knowledge
7. **Practice coding** - LeetCode medium problems
8. **Build projects** - GitHub portfolio speaks volumes
9. **Know your past projects** - Be ready to discuss them deeply
10. **Follow up** - "Can I optimize this further?"

---

**Good luck with your Node.js interviews!** 🚀
