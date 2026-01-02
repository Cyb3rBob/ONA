from scapy.all import *

def forward_packet(packet, dest1, dest2):
    packet1 = packet.copy()
    packet2 = packet.copy()
    sendp(packet1, iface="eth0", dst=dest1)
    sendp(packet2, iface="eth0", dst=dest2)

def process_packet(packet):
    if packet.haslayer(IP) and packet.haslayer(UDP) and packet[UDP].dport == 80:  # Change 80 to your desired UDP port
        forward_packet(packet, "192.168.1.10", "192.168.1.20")

def sniff_packets(interface):
    sniff(filter="ip", prn=process_packet, iface=interface)

# Specify the interface
input_interface = "eth1"  # Change this to the desired interface
sniff_packets(input_interface)
