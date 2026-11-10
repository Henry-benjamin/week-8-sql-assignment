// redis/cache_service.js
// SpendWise Enterprise - Redis Caching Layer Integration
// Handles high-frequency user sessions and recent transaction buffers to reduce PostgreSQL load.

const Redis = require("redis");
const redisClient = Redis.createClient({
  url: process.env.REDIS_URL || "redis://localhost:6379",
});

redisClient.on("error", (err) => console.error("Redis Client Error", err));

async function connectRedis() {
  await redisClient.connect();
  console.log("Connected to Redis NoSQL Layer successfully.");
}

// Cache active user session to avoid repeated DB lookups
async function cacheUserSession(userId, sessionData, ttlSeconds = 3600) {
  const key = `session:${userId}`;
  await redisClient.setEx(key, ttlSeconds, JSON.stringify(sessionData));
}

// Retrieve cached recent transactions for sub-millisecond dashboard loads
async function getCachedRecentTransactions(accountId) {
  const key = `transactions:recent:${accountId}`;
  const data = await redisClient.get(key);
  return data ? JSON.parse(data) : null;
}

module.exports = {
  connectRedis,
  cacheUserSession,
  getCachedRecentTransactions,
};
