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
