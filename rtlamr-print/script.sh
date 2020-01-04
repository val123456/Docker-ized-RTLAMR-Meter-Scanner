# re-ru "docker compose build" after editing this file

# colors for output
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "\n${RED}Starting rtl_tcp:\n"

# if looking for all meter types, change to the following to hide ll+ messages  
# rtl_tcp > /dev/null &
rtl_tcp &

# wait for rtl_tcp to initialize 
sleep 5

# Uncomment the next four lines to look for all meter types, Will probably generate errors from rtl_tcp on low-powered systems
# But program will still work with correct meter data
# echo -e "\n${RED}Starting rtlamr looking for all meters only, may generate many \"ll+, now \" messages from rtl_tcp on low powered systems${NC}"
# echo -e "\n${RED}Output printed to display (STDOUT) and written to file in ../meter_data/meters.txt${NC}\n"
# sleep 5
# /root/go/bin/rtlamr -format=json -unique=false -msgtype=all | tee -a /data/meters.txt ; exit


echo -e "\n${RED}Starting rtlamr looking for SCM meters only"
echo -e "\n${RED}Edit script.sh file to look for all meter types"
echo -e "\n${RED}Output printed to display (STDOUT) and written to file in ../meter_data/meters.txt\n"
sleep 5
/root/go/bin/rtlamr -format=json -unique=false -msgtype=scm | tee -a /data/meters.txt
