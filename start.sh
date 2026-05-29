#!/bin/bash
# Honcho Startup Script for Railway
# Runs migrations before starting the API

echo "======================================"
echo "Starting Honcho on Railway"
echo "======================================"

# Wait for database to be ready
echo "Waiting for PostgreSQL..."
sleep 5

# Run migrations
echo "Running database migrations..."
honcho migrate up

# Start the API server
echo "Starting Honcho API server..."
exec honcho serve