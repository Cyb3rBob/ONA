#!/bin/bash

# --- PURPOSE --- 
# This script shows how many pieces of data (packets) are entering (RX) 
# and leaving (TX) your computer every second.
#
# --- QUICK SETUP ---
# 1. Login to your PNM/ONA sensor.  Change Directory to /usr/local/bin directory. (e.g., cd /usr/local/bin)
#    This location is commonly used for custom scripts that should be
#    available to all users on the system.
# 2. Type: sudo wget https://raw.githubusercontent.com/Cyb3rBob/ONA/refs/heads/master/netpps.sh
#    This will automatically download the file to your system.
# 2. Give permission so anyone can run it:  sudo chmod +x /usr/local/bin/netpps.sh
# 
# --- HOW TO RUN: ---
# 1. Find your interface name by running the command:  ip addr
#    If you have more then one interface, make sure you pick the one with the correct IP Address.
#    Run this script xample: netpps.sh <interface_name>  (e.g., netpps.sh eth0)
# 2. To stop Press: CTRL + C
#
# Configuration
INTERVAL=${2:-1} # Defaults to 1s if second argument is missing
IF=$1

# Validation: Check if interface argument was provided
if [ -z "$IF" ]; then
    echo "Usage: $0 [interface] [interval_seconds]"
    exit 1
fi
#
# Validation: Check if interface exists
if [ ! -d "/sys/class/net/$IF" ]; then
    echo "Error: Interface '$IF' not found."
    exit 1
fi
#
echo
echo "Monitoring $IF (Press CTRL+C to stop)..."
echo
#
while true
do
    R1=$(cat /sys/class/net/"$IF"/statistics/rx_packets)
    T1=$(cat /sys/class/net/"$IF"/statistics/tx_packets)
    
    sleep "$INTERVAL"
    
    R2=$(cat /sys/class/net/"$IF"/statistics/rx_packets)
    T2=$(cat /sys/class/net/"$IF"/statistics/tx_packets)
    
    # Calculate using Bash arithmetic expansion
    TXPPS=$(( (T2 - T1) / INTERVAL ))
    RXPPS=$(( (R2 - R1) / INTERVAL ))
    
    # \r returns the cursor to the start of the line; -n prevents a new line
    printf "\rTX %s: %-7d pkts/s  |  RX %s: %-7d pkts/s" "$IF" "$TXPPS" "$IF" "$RXPPS"
done
