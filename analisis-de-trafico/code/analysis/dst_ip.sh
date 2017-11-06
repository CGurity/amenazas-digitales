echo "Dumping destination ips in $folder/dst_ip.txt"
touch $folder/dst_ip.txt
tshark -T fields -e ip.dst -r $folder/capture.pcap | sort | uniq > $folder/dst_ip.txt
