const mongoose = require('mongoose');
const dns = require('dns');

// Ensure reliable SRV record resolution on Windows for MongoDB Atlas
try {
  dns.setServers(['8.8.8.8', '8.8.4.4']);
} catch (_) {}

const connectDB = async () => {
  try {
    const conn = await mongoose.connect(process.env.MONGODB_URI || 'mongodb://127.0.0.1:27017/sahyan');
    console.log(`MongoDB Connected: ${conn.connection.host}`);
  } catch (error) {
    console.error(`Database Connection Error: ${error.message}`);
    // Continue in offline fallback mode if database is not reachable locally
  }
};

module.exports = connectDB;
