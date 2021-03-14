#!/usr/bin/env bash

# Install cloudflared
wget https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-amd64.rpm
yum -y install cloudflared-stable-linux-amd64.rpm
rm -f cloudflared-stable-linux-amd64.rpm

# Get cert.pem from Secrets Manager
mkdir -p /etc/cloudflared
aws secretsmanager get-secret-value --secret-id ${cert_pem_secret_id} --query SecretString --output text --region ${aws_region} > /etc/cloudflared/cert.pem

# Create a tunnel
RANDOM_TUNNEL_NAME=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 8 ; echo '')
/usr/local/bin/cloudflared tunnel create $RANDOM_TUNNEL_NAME
TUNNEL_UUID=$(/usr/local/bin/cloudflared tunnel list | awk '{x=$1}END{print x}')

# Create DNS entries
/usr/local/bin/cloudflared tunnel route dns $TUNNEL_UUID ${my_service_domain}

# Create config file for multiple hostnames
cat << EOF > /etc/cloudflared/config.yml
tunnel: $TUNNEL_UUID
credentials-file: /etc/cloudflared/$TUNNEL_UUID.json

ingress:
  - hostname: ${my_service_hostname}
    service: ${my_service_url}
  - service: http_status:404
EOF

# Start Cloudflared service
/usr/local/bin/cloudflared service install
