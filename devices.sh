#!/bin/bash

# file to save captured exporter ip addresses
# copy file to /usr/local/bin.  This is the best place so they are available to everyone who logs in.
# set script rights so anyone can run it:  sudo chmod 755 devices.sh
# Make the script executable:  sudo chmod +x devices.sh
# Change the port numbers as needed and the count as well.  Higher count is better for a large environment
# with lots of traffic.  (ex: -c 5000) or even more in high traffic environments.
# run script:   ./devices.sh
OUTPUT_FILE='exporters.txt'

# tcpdump command
tcpdump -nn -l udp port 9997 or udp port 9995 -c 100  2>/dev/null | \
awk '{print $3}' | cut -d. -f1-4 | sort | uniq > "$OUTPUT_FILE"

# count number of devices using word count
echo "Total IPs: $(wc -l < "$OUTPUT_FILE")" >> $OUTPUT_FILE
echo ""
cat $OUTPUT_FILE
echo ""
echo "Source IP addresses sending Netflow are saved in $OUTPUT_FILE"
echo ""

