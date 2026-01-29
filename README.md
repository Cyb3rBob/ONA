All the scripts in this repository are available for use by anyone.  
All the scripts in this repository are meant to address questions or capabilities inside of Cisco XDR Analytics's PNM/ONA Sensor, though they will likely work on any linux workstation or server.

netpps.sh = script to see the number of packets per second an interface is sending or receiving.  The value gets updated every second.  It can be used to see how much traffic is being sent to an interface.
The script doesn't record data long term, or compare it to any standard values.  Setup SNMP on your server if you need to see long term trends etc...

netspeed.sh = script to see how much traffic is being sent to an interface, expressed in kB/s.  (KiloBytes per second).  Remember a byte is made up of 8bits, so 100,000 Kilobytes would be 800 mb/s. (megabits per second)
Most interfaces are 1 Gig these days or better.  So you can get a basic understanding of how much traffic is coming into and out of an interface using this script. 

