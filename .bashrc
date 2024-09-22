# Run the startup script
./.startup.sh

# Ensure that the wake lock is applied
termux-wake-lock

# Function to check if a port is in use
is_port_in_use() {
  local port=$1
  if lsof -i :$port > /dev/null 2>&1; then
    return 0  # Port is in use
  else
    return 1  # Port is not in use
  fi
}

# Function to check if a process is running by its exact name
is_process_running() {
  local process_name=$1
  if pgrep -f -x "$process_name" > /dev/null; then
    return 0  # Process is running
  else
    return 1  # Process is not running
  fi
}

# Define ports
SSHD_PORT=8282
NGINX_PORT=8080

# Start nginx if not already running
if ! is_process_running "nginx: master process nginx" && ! is_port_in_use $NGINX_PORT; then
  echo "  - Nginx is not running."
  echo "    Starting Nginx..."
  nginx
  if is_process_running "nginx: master process nginx"; then
    echo "    Nginx started."
  else
    echo "    Failed to start Nginx."
  fi
else
  echo "  - Nginx is running."
fi

# Start sshd if not already running
if ! is_process_running "sshd" && ! is_port_in_use $SSHD_PORT; then
  echo "  - SSHD is not running."
  echo "    Starting SSHD..."
  sshd
  if is_process_running "sshd"; then
    echo "    SSHD started."
  else
    echo "    Failed to start SSHD."
  fi
else
  echo "  - SSHD is running."
fi

# Check if Cloudflare tunnel is running
if ! is_process_running "cloudflared tunnel run expose"; then
  echo "  - Cloudflared is not running."
  echo "    Starting Cloudflared..."
  cloudflared tunnel run expose > /data/data/com.termux/files/home/cloudflared.log 2>&1 &
  sleep 5  # Allow time for Cloudflared to start

  if is_process_running "cloudflared tunnel run expose"; then
    echo "    Cloudflared started."
  else
    echo "    Failed to start Cloudflared."
  fi
else
  echo "  - Cloudflared is running."
fi
