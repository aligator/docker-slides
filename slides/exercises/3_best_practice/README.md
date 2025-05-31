# Express Web App Solution

This solution demonstrates how to containerize a simple Express backend and HTML frontend.

## Structure
- `backend/`: Express server
- `frontend/`: Simple HTML page
- `docker-compose.yml`: Orchestrates both services

## How to Run
1. Build and start the services:
```bash
docker compose up --build
```

2. Access the services:
- Frontend: http://localhost:8080
- Backend API: http://localhost:3000/api

## Key Points
- Backend uses Node.js image
- Frontend uses Nginx to serve static files
- Services communicate through Docker network
- Ports are mapped for external access 