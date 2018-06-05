echo "Comparing found ips with blacklist files and dumping results in $folder/blacklisted_ips.txt"
touch $folder/blacklisted_ips.txt
# This file must be executed after dst_ip.sh and the system must have grepcidr to work properly

grepcidr -f $folder/dst_ip.txt ./input/ip_blacklist/list.txt > $folder/blacklisted_ips.txt
