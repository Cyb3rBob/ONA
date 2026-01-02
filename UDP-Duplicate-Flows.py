# Makes a duplicate of a UDP packet that can be sent to two different destinations
# The origional intent is to allow multiple NetFlow flow-flow collectors to receive packets 
# from a single exporter


from scapy.all import *

def forward_packet(packet, dest1, dest2):
    packet1 = packet.copy()
    packet2 = packet.copy()
    sendp(packet1, iface="eth0", dst=dest1)
    sendp(packet2, iface="eth0", dst=dest2)

def process_packet(packet):
    if packet.haslayer(IP) and packet.haslayer(UDP) and packet[UDP].dport == 2055:  # Change 2055 to your desired UDP port
        forward_packet(packet, "192.168.1.10", "192.168.1.20") # Change to ip address of UDP Receivers

def sniff_packets(interface):
    sniff(filter="ip", prn=process_packet, iface=interface)

# Specify the interface
input_interface = "eth1"  # Change this to the desired interface
sniff_packets(input_interface)

