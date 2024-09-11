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

# Function to check if a process is running by name with arguments
is_process_running() {
  local process_name=$1
  if ps aux | grep "[${process_name:0:1}]${process_name:1}" > /dev/null; then
    return 0  # Process is running
  else
    return 1  # Process is not running
  fi
}

# Start nginx if port 8080 is not in use
PORT=8080
if is_port_in_use $PORT; then
  echo "  - Nginx is running on port $PORT."
else
  echo "  - Nginx is not running. Starting nginx..."
  nginx
  if is_port_in_use $PORT; then
    echo "  - Nginx started successfully on port $PORT."
  else
    echo "  - Failed to start Nginx on port $PORT."
  fi
fi

# Start sshd if not already running
if ! is_process_running "sshd"; then
  echo "  - SSHD is not running. Starting SSHD..."
  sshd
  if [ $? -eq 0 ]; then
    echo "  - SSHD started successfully."
  else
    echo "  - Failed to start SSHD."
  fi
else
  echo "  - SSHD is running."
fi

# Start crond if not already running
if ! is_process_running "crond"; then
  echo "  - Crond is not running. Starting Crond..."
  crond
  if [ $? -eq 0 ]; then
    echo "  - Crond started successfully."
  else
    echo "  - Failed to start Crond."
  fi
else
  echo "  - Crond is running."
fi

# Check if Cloudflare is already running
if is_process_running "cloudflared tunnel run ssh"; then
  echo "  - Cloudflare tunnel is running."
else
  echo "  - Cloudflare tunnel is not running. Starting Cloudflare tunnel..."
  cloudflared tunnel run ssh > /data/data/com.termux/files/home/cloudflared.log 2>&1 &
  CLOUDFLARED_PID=$!
  sleep 5  # Allow time for Cloudflare to start

  if ps -p $CLOUDFLARED_PID > /dev/null; then
    echo "  - Cloudflare tunnel is running successfully."
  else
    echo "  - Failed to start Cloudflare tunnel."
  fi
fi

# Add a blank line
echo
