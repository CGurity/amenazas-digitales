echo "Dumping destination ips in $folder/user_agents.txt"
touch $folder/user_agents.txt
tshark -r $folder/capture.pcap -Y http.request -T fields -e http.host -e http.user_agent | sort | uniq -c | sort -n > $folder/user_agents.txt
