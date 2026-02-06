# test-posts.sh

#!/usr/bin/env bash

# ================================================
# Test Script for ChatSocial Posts API
# Run with: bash test-posts.sh
# ================================================

set -e  # exit on error

# === CONFIG ===
BASE_URL="http://localhost:5000"
AUTH_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2OTg1ZDI1OGFjZjM4Y2MyYThlMTIzZjciLCJpYXQiOjE3NzAzODI1NzYsImV4cCI6MTc3MDk4NzM3Nn0.st2_t1-cJLHsXHMmFMuzqIkSTX3D8_A2JNPTPzLV3Gs"   # ← PASTE YOUR REAL JWT TOKEN HERE AFTER LOGIN
                # How to get token: login via test-auth.sh or Postman,
                # copy the "token" value from response

# === FUNCTIONS ===
check_token() {
  if [ -z "$AUTH_TOKEN" ]; then
    echo "ERROR: AUTH_TOKEN is empty."
    echo "1. Run test-auth.sh first to login"
    echo "2. Copy the 'token' value from the login response"
    echo "3. Paste it into AUTH_TOKEN=\"\" above"
    exit 1
  fi
}

# === START ===
echo "========================================"
echo "  Testing ChatSocial Posts API"
echo "  Base URL: $BASE_URL"
echo "  Token: ${AUTH_TOKEN:0:10}... (hidden)"
echo "========================================"
echo ""

check_token

# ─────────────────────────────────────────────
echo "1. GET /api/posts (fetch feed)"
echo "----------------------------------------"

curl -s -X GET "$BASE_URL/api/posts" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $AUTH_TOKEN" | python -m json.tool 2>/dev/null || echo "(raw response)"

echo ""
echo "────────────────────────────────────────"
echo ""

# ─────────────────────────────────────────────
echo "2. POST /api/posts (create a new post)"
echo "----------------------------------------"

curl -s -X POST "$BASE_URL/api/posts" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -d '{
    "content": "This is my first test post from the test script! 🚀"
  }' | python -m json.tool 2>/dev/null || echo "(raw response)"

echo ""
echo "────────────────────────────────────────"
echo ""

echo "Test completed."
echo "If both requests return proper JSON → backend posts are working!"
echo ""