import express from "express";
import cors from "cors";
import apiRoutes from "./src/routes/index.js";

const app = express();
const PORT = process.env.PORT || 3000;

// ==========================================
// 1. Middleware Setup
// ==========================================
// Allow requests from the Flutter app (or any origin during the hackathon)
app.use(cors());

// Automatically parse incoming JSON payloads in the request body
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
// If flutter web sends it as text/plain
app.use(express.text({ type: "text/plain" }));

// Middleware to manually parse JSON if it comes as text
app.use((req, res, next) => {
  if (typeof req.body === "string" && req.body.startsWith("{")) {
    try {
      req.body = JSON.parse(req.body);
    } catch (e) {
      // ignore
    }
  }
  next();
});

// ==========================================
// 2. Health Check Route
// ==========================================
// A simple endpoint to verify the server is alive
app.get("/api/health", (req, res) => {
  res.json({
    status: "online",
    message: "ArabPay API Gateway is running smoothly.",
  });
});

// ==========================================
// 3. Mount Application Routes (Coming Soon)
// ==========================================
app.use("/api", apiRoutes);

// ==========================================
// 4. Start the Server
// ==========================================
app.listen(PORT, () => {
  console.log(`🚀 ArabPay API Gateway running on http://localhost:${PORT}`);
  console.log(
    `-> Health check available at: http://localhost:${PORT}/api/health`,
  );
});
