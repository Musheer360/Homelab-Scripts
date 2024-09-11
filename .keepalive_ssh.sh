#!/bin/bash

# Check if sshd is running, and start it if not
if ! ps aux | grep "[s]shd" > /dev/null
then
    sshd
fi

# Check if nginx is running on port 8080, and start it if not
PORT=8080
if ! lsof -i :$PORT > /dev/null 2>&1
then
    nginx
fi

# Check if Cloudflare tunnel is running
if ! ps aux | grep "[c]loudflared tunnel run ssh" > /dev/null
then
    cloudflared tunnel run ssh > /data/data/com.termux/files/home/cloudflared.log 2>&1 &
fi
