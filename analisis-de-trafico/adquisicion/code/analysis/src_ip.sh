echo "Dumping destination ips in $folder/src_ip.txt"
touch $folder/src_ip.txt
tshark -T fields -e ip.src -r $folder/capture.pcap | sort | uniq > $folder/src_ip.txt
