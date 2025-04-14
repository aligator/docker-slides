# Build stage
FROM golang:1.21-alpine AS builder

# Install git and build dependencies
RUN apk add --no-cache git

# Download slides
RUN go install github.com/maaslalani/slides@latest

# Final stage
FROM alpine:latest

# Install runtime dependencies
RUN apk add --no-cache ca-certificates

# Copy the slides binary from builder
COPY --from=builder /go/bin/slides /usr/local/bin/slides

# Create a directory for slides
WORKDIR /slides

COPY --chmod=777 ./slides/*.md /slides

# Set the entrypoint to slides
ENTRYPOINT ["slides", "serve", "--keyPath", "/keys/slides", "--host", "0.0.0.0"]

# Default command (can be overridden)
CMD ["level1.md"] 