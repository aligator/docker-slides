# Build stage
FROM node:20-slim AS builder
WORKDIR /app

# Copy package files first for better caching
COPY package*.json ./
RUN npm ci

# Copy source files
COPY . .

# Production stage
FROM node:20-slim
WORKDIR /app

# Create non-root user
RUN adduser --disabled-password --gecos "" appuser

# Copy only necessary files from builder
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/*.js ./
RUN npm ci --only=production

# Set proper permissions
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

EXPOSE 3000
ENTRYPOINT ["node"]
CMD ["server.js"] 