#!/usr/bin/env bash

# test-auth.sh (updated – no jq required)

set -e

BASE_URL="http://localhost:5000"
EMAIL="testuser@example.com"
PASSWORD="password123"
NAME="Test User"

echo "========================================"
echo "  Testing ChatSocial Backend Auth API"
echo "  Base URL: $BASE_URL"
echo "========================================"
echo ""

echo "1. Trying to REGISTER a new user..."
echo "----------------------------------------"
REGISTER_RESPONSE=$(curl -s -X POST "$BASE_URL/api/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "'"$NAME"'",
    "email": "'"$EMAIL"'",
    "password": "'"$PASSWORD"'"
  }')

echo "$REGISTER_RESPONSE" | python -m json.tool 2>/dev/null || echo "$REGISTER_RESPONSE"
echo ""

echo "----------------------------------------"
echo ""

echo "2. Trying to LOGIN with the same credentials..."
echo "----------------------------------------"
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "'"$EMAIL"'",
    "password": "'"$PASSWORD"'"
  }')

echo "$LOGIN_RESPONSE" | python -m json.tool 2>/dev/null || echo "$LOGIN_RESPONSE"
echo ""

echo "========================================"
echo "Test completed."