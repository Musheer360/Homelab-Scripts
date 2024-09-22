#!/bin/bash

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

# Check if sshd is not running and port 8282 is not in use, start it if both conditions are true
SSHD_PORT=8282
if ! is_process_running "sshd" && ! is_port_in_use $SSHD_PORT; then
    sshd
fi

# Check if nginx is not running and port 8080 is not in use, start it if both conditions are true
NGINX_PORT=8080
if ! is_process_running "nginx: master process nginx" && ! is_port_in_use $NGINX_PORT; then
    nginx
fi

# Check if Cloudflare tunnel is not running, start it if true
if ! is_process_running "cloudflared tunnel run expose"; then
    cloudflared tunnel run expose > /data/data/com.termux/files/home/cloudflared.log 2>&1 &
fi
