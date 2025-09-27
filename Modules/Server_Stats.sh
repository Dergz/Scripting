## Module, Server stats, IP, hwinfo,etc

## IP ADDR
IP_ADDR_V4(){
lanIp="$(ip -4 -o -br addr|awk '$0 ~ /^[we]\w+\s+UP\s+/ {str = gsub("/[1-9][0-9]*", "", $0); print $3}')";
#wanIp="$(curl https://ipinfo.io/ip 2>/dev/null)";
echo "###      ip Addr     ###"
echo " IP:  ${lanIp}";  ##Grabs machines local net ip addr
echo " MDNS:   suwuver" ##Static to tailscale magicDNS name
#echo "Your public ip is: ${wanIp}";
}

## Disk Space
TDS="$(df $PWD -kh | awk '/[0-9]%/{print $(NF-4)}')" ## Total Disk Space
UDS="$(df $PWD -kh | awk '/[0-9]%/{print $(NF-3)}')" ## Used Disk Space
ODS="$(df $PWD -kh | awk '/[0-9]%/{print $(NF-2)}')" ## Open Disk Space

Disk_Usage(){
    echo ""
    echo "###    Disk Stats    ###"
    printf " Total Disk Space: "
    echo "$TDS"
    printf " Open Disk Space:  "
    echo "$ODS"
    printf " Used Disk Space:  "
    echo "$UDS"
}

##  Date
Date(){
    printf "Date: "
    current_date_time="$(date "+%Y-%m-%d")";
    echo $current_date_time;
}