#!/bin/bash

# Create certs directory if it doesn't exist
mkdir -p certs

# Generate private key
openssl genrsa -out certs/key.pem 2048

# Generate certificate
openssl req -new -x509 -key certs/key.pem -out certs/cert.pem -days 365 -subj "/C=US/ST=State/L=City/O=Organization/OU=OrgUnit/CN=localhost"

echo "Self-signed certificates generated in certs/ directory"
echo "You can now run 'pnpm run serve' and access https://127.0.0.1:8080"
echo "Note: You'll need to accept the security warning in your browser"