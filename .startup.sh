#!/bin/bash

# Get the current date and time
DATE=$(date "+%d/%m/%y")
TIME=$(date "+%I:%M %p")  # 12-hour format with AM/PM

# Display date and time
echo "Today's date: $DATE"
echo "Current time: $TIME"

# Add a blank line
echo

# Display system uptime without the word "up"
UPTIME=$(uptime -p | sed 's/up //')
echo "The system is up for $UPTIME."

# Get Memory usage
MEMORY_USAGE=$(free -m | awk 'NR==2{print $3}')
MEMORY_TOTAL=$(free -m | awk 'NR==2{print $2}')
MEMORY_PERCENTAGE=$(awk "BEGIN {printf \"%.2f\", (${MEMORY_USAGE} * 100.0 / ${MEMORY_TOTAL})}")

# Format and display Memory usage
echo -e "\nMemory Usage: ${MEMORY_USAGE} MB / ${MEMORY_TOTAL} MB (${MEMORY_PERCENTAGE}%)"

# Get IP address
IP_ADDR=$(ifconfig | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | head -n 1)
echo -e "\nIP Address: $IP_ADDR"

# Get System Load Average
LOAD_AVG=$(uptime | awk -F'[a-z]:' '{ print $2}' | tr -d ',')
LOAD_1=$(echo $LOAD_AVG | awk '{print $1}')
LOAD_5=$(echo $LOAD_AVG | awk '{print $2}')
LOAD_15=$(echo $LOAD_AVG | awk '{print $3}')

# Convert Load Average to percentage and format
LOAD_1_PERCENT=$(awk "BEGIN {printf \"%.0f%%\", (${LOAD_1} * 100)}")
LOAD_5_PERCENT=$(awk "BEGIN {printf \"%.0f%%\", (${LOAD_5} * 100)}")
LOAD_15_PERCENT=$(awk "BEGIN {printf \"%.0f%%\", (${LOAD_15} * 100)}")

# Display System Load Average
echo -e "\nSystem Load Average:"
echo -e "  - 1 minute:    $LOAD_1_PERCENT"
echo -e "  - 5 minutes:   $LOAD_5_PERCENT"
echo -e "  - 15 minutes:  $LOAD_15_PERCENT"

# Add a blank line
echo
