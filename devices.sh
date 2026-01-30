#!/bin/bash

# --- PURPOSE --- 
# This script identifies all of the NetFlow Exporters (Routers/switches/firewalls)
# that are sending telemetry (NetFlow) to your PNM/ONA Sensor.
#
# --- QUICK SETUP ---
# 1. Login to your PNM/ONA sensor.  Change Directory to /usr/local/bin directory. (e.g., cd /usr/local/bin)
#    This location is commonly used for custom scripts that should be
#    available to all users on the system.
# 2. Type: sudo wget https://raw.githubusercontent.com/Cyb3rBob/ONA/refs/heads/master/devices.sh
#    This will automatically download the file to your system.
# 2. Give permission so anyone can run it:  sudo chmod +x /usr/local/bin/devices.sh
# 
# --- HOW TO RUN: ---
# 1. Type: sudo devices.sh
#    This script must be run with higher privliges to give the tcpdump binary the ability to capture packets
#    and write the exporters.txt file to a restricted directory. 
# 2. Script will automatically stop after the set number of packets is received.  By default this is 
#    10,000 packets.  This may need to be increased or decreased depending on how much telemetry
#    is being sent to your sensor.

# Configuration
OUTPUT_FILE="exporters.txt"
INTERFACE="any"
PORTS="9995 or 9997"  # change port numbers to ports used on your sensor.  (e.g., 2055, 9996 etc..)
CAPTURE_COUNT=10000   # Increase or decrease capture count as needed based on how much traffic is 
#                       being sent to your sensor.  (Higher = longer capture period)

# temporary file to prevent accidental overwrites if the script fails
TMP_FILE=$(mktemp)

echo "Capturing $CAPTURE_COUNT packets on ports: $PORTS..."

tcpdump -i "$INTERFACE" -nn -q -c "$CAPTURE_COUNT" "udp port $PORTS" 2>/dev/null | \
    grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | \
    sort -u > "$TMP_FILE"

IP_COUNT=$(wc -l < "$TMP_FILE")

{
    cat "$TMP_FILE"
    echo "---"
    echo "Total IPs: $IP_COUNT"
    echo "Timestamp: $(date)"
} > "$OUTPUT_FILE"

cat "$OUTPUT_FILE"
rm "$TMP_FILE"

echo -e "\nSource IP addresses saved to $OUTPUT_FILE"

