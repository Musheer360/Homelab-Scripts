#!/bin/bash

# Check if sshd is running, and start it if not
if ! pgrep -x "sshd" > /dev/null
then
    sshd
fi

# Check if the redirection rule already exists
if su -c "/system/bin/iptables -t nat -L PREROUTING -n -v | grep -q 'tcp dpt:22 redir ports 8022'"; then
    # Rule already exists, no action needed
    :
else
    # Add the redirection rule
    su -c "/system/bin/iptables -t nat -A PREROUTING -p tcp --dport 22 -j REDIRECT --to-port 8022"
fi
