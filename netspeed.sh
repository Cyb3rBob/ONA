#!/bin/bash

# --- PURPOSE --- 
# This script shows how many Kilobytes per second are entering . 
# and leaving your PNM/ONA sensor every second.
#
# --- QUICK SETUP ---
# 1. Use WinSCP or some similar tool to copy the file to: /usr/local/bin on your PNM/ONA Sensor. 
#    This location is commonly used for custom scripts that should be
#    available to all users on the system.
# 2. Give permission so anyone can run it:  sudo chmod +x /usr/local/bin/netspeed.sh
# 
# --- HOW TO RUN: ---
# 1. Find your interface name by running the command:  ip link
#    If you have more then one interface, make sure you pick the one with the correct IP Address.
#    Run this script xample: netspeed.sh <interface_name>  (e.g., netspeed.sh eth0)
# 2. To stop Press: CTRL + C

# Configuration
# Ensure an interface was provided
if [[ -z "$1" ]]; then
    echo "Usage: $0 [interface]"
    exit 1
fi

INTERFACE=$1
INTERVAL=1

# Check if the interface exists in sysfs before starting
if [[ ! -d "/sys/class/net/$INTERFACE" ]]; then
    echo "Error: Interface $INTERFACE not found."
    exit 1
fi

echo
echo "Monitoring $INTERFACE (Press CTRL+C to stop)..."
echo

# Use local variables and modern expansion
while true; do
    # Read initial bytes
    R1=$(cat "/sys/class/net/$INTERFACE/statistics/rx_bytes")
    T1=$(cat "/sys/class/net/$INTERFACE/statistics/tx_bytes")
    
    sleep "$INTERVAL"
    
    # Read bytes after interval
    R2=$(cat "/sys/class/net/$INTERFACE/statistics/rx_bytes")
    T2=$(cat "/sys/class/net/$INTERFACE/statistics/tx_bytes")
    
    # Use Bash Arithmetic for better performance than 'expr'
    RBPS=$(( (R2 - R1) / 1024 ))
    TBPS=$(( (T2 - T1) / 1024 ))
    
    # \r (carriage return) keeps the output on a single line for a cleaner UI
    printf "\rTX %s: %d kB/s | RX %s: %d kB/s" "$INTERFACE" "$TBPS" "$INTERFACE" "$RBPS"
done
