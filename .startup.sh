#!/bin/bash

# Get the current date and time
DATE=$(date "+%d/%m/%y")
TIME=$(date "+%I:%M %p")  # 12-hour format with AM/PM

# Display date and time
echo "Today's date: $DATE"
echo "Current time: $TIME"
echo

# Display system uptime without the word "up"
UPTIME=$(uptime -p | sed 's/up //')
echo "System Uptime: $UPTIME"
echo

# Get CPU Temperature
CPU_TEMP=$(cat /sys/class/thermal/thermal_zone0/temp)
echo -e "CPU Temperature: ${CPU_TEMP}°C"
echo

# Get Memory usage
MEMORY_USAGE=$(free -m | awk 'NR==2{print $3}')
MEMORY_TOTAL=$(free -m | awk 'NR==2{print $2}')
MEMORY_PERCENTAGE=$(awk "BEGIN {printf \"%.0f\", (${MEMORY_USAGE} * 100.0 / ${MEMORY_TOTAL})}")

# Format and display Memory usage
echo -e "Memory Usage: ${MEMORY_USAGE} MB / ${MEMORY_TOTAL} MB (${MEMORY_PERCENTAGE}%)"
echo

# Get Disk Usage
DISK_INFO=$(df -h /storage/emulated | awk 'NR==2 {print $3, $2, $5}')
USED_DISK=$(echo $DISK_INFO | awk '{print $1}' | sed 's/M/ MB/; s/G/ GB/')
TOTAL_DISK=$(echo $DISK_INFO | awk '{print $2}' | sed 's/M/ MB/; s/G/ GB/')
USAGE_PERCENT=$(echo $DISK_INFO | awk '{print $3}')

# Display Disk Usage
echo -e "Disk Usage: $USED_DISK / $TOTAL_DISK ($USAGE_PERCENT)"
echo

# Get IP address
IP_ADDR=$(ifconfig | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | head -n 1)
echo -e "IP Address: $IP_ADDR"
echo

# Get System Load Average
LOAD_AVG=$(uptime | awk -F'[a-z]:' '{ print $2}' | tr -d ',')
LOAD_1=$(echo $LOAD_AVG | awk '{print $1}')
LOAD_5=$(echo $LOAD_AVG | awk '{print $2}')
LOAD_15=$(echo $LOAD_AVG | awk '{print $3}')

# Display System Load Average
echo -e "System Load Average:\n"
echo -e "  - 1 minute:    $LOAD_1"
echo -e "  - 5 minutes:   $LOAD_5"
echo -e "  - 15 minutes:  $LOAD_15"
echo

# Get Battery Status
BATTERY_STATUS=$(termux-battery-status)
BATTERY_PERCENTAGE=$(echo "$BATTERY_STATUS" | grep -oP '"percentage":\s*\K\d+')
BATTERY_STATE=$(echo "$BATTERY_STATUS" | grep -oP '"status":\s*"\K[^"]+' | sed 's/\(.*\)/\L\1/' | sed 's/^./\U&/')
BATTERY_TEMP=$(echo "$BATTERY_STATUS" | grep -oP '"temperature":\s*\K[\d.]+' | awk '{printf "%.0f", $1}')
BATTERY_PLUGGED=$(echo "$BATTERY_STATUS" | grep -oP '"plugged":\s*"\K[^"]+')

# Determine the plug status
if [[ "$BATTERY_PLUGGED" == "PLUGGED_AC" || "$BATTERY_PLUGGED" == "PLUGGED_USB" ]]; then
    PLUG_STATUS="Plugged-in"
else
    PLUG_STATUS="Unplugged"
fi

# Display Battery Status
echo -e "Battery Status:\n"
echo -e "  - Percentage:  $BATTERY_PERCENTAGE%"
echo -e "  - Temperature: ${BATTERY_TEMP}°C"
echo -e "  - Status:      $PLUG_STATUS ($BATTERY_STATE)"

# Display services status (continuation in .bashrc file)
echo -e "\nServices status:"
echo
