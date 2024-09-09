# Run the startup script
./.startup.sh

# Ensure that the wake lock is applied
termux-wake-lock

# Start sshd if not already running
if ! pgrep -x "sshd" > /dev/null
then
  sshd
fi

# Start crond if not already running
if ! pgrep -x "crond" > /dev/null
then
  crond
fi

# Check if the redirection rule already exists
if su -c "/system/bin/iptables -t nat -L PREROUTING -n -v | grep -q 'tcp dpt:22 redir ports 8022'"; then
    # Rule already exists, no action needed
    :
else
    # Add the redirection rule
    su -c "/system/bin/iptables -t nat -A PREROUTING -p tcp --dport 22 -j REDIRECT --to-port 8022"
fi
