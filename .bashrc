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

# Start nginx if not running and port 8080 is not in use
NGINX_PORT=8080
if ! is_process_running "nginx: master process nginx" && ! is_port_in_use $NGINX_PORT; then
  echo "  - Nginx is not running."
  echo "    Starting nginx..."
  nginx
  if is_port_in_use $NGINX_PORT; then
    echo "    Nginx started."
  else
    echo "    Failed to start Nginx."
  fi
else
  echo "  - Nginx is running."
fi

# Start sshd if not running and port 8282 is not in use
SSHD_PORT=8282
if ! is_process_running "sshd" && ! is_port_in_use $SSHD_PORT; then
  echo "  - SSHD is not running."
  echo "    Starting SSHD..."
  sshd
  if is_port_in_use $SSHD_PORT; then
    echo "    SSHD started."
  else
    echo "    Failed to start SSHD."
  fi
else
  echo "  - SSHD is running."
fi

# Start crond if not already running
if ! is_process_running "crond"; then
  echo "  - Crond is not running."
  echo "    Starting Crond..."
  crond
  if is_process_running "crond"; then
    echo "    Crond started."
  else
    echo "    Failed to start Crond."
  fi
else
  echo "  - Crond is running."
fi

# Check if Cloudflared is already running
if is_process_running "cloudflared tunnel run expose"; then
  echo "  - Cloudflared is running."
else
  echo "  - Cloudflared is not running."
  echo "    Starting Cloudflared..."
  cloudflared tunnel run expose > /data/data/com.termux/files/home/cloudflared.log 2>&1 &
  CLOUDFLARED_PID=$!
  sleep 5  # Allow time for Cloudflared to start
  if ps -p $CLOUDFLARED_PID > /dev/null; then
    echo "    Cloudflared started."
  else
    echo "    Failed to start Cloudflared."
  fi
fi

# Add a blank line
echo
