#!/bin/bash

file=task4_1.out

#Hardware:
echo "--- Hardware ---" > $file

cpu=`cat /proc/cpuinfo | grep 'model name' | uniq | cut -d : -f2`
echo "CPU:$cpu" >> $file

echo "RAM: `free -m | grep Mem | awk '{ print $2; }'`" >> $file

#LIST=`/usr/sbin/dmidecode -t baseboard | grep -E "Manufacture|Product Name|Version"`
#mapfile -t strings < <(echo "$LIST")
#echo "Motherboard:`echo ${strings[0]} | cut -d : -f2` /`echo ${strings[1]} | cut -d : -f2` /`echo ${strings[2]} | cut -#d : -f2`"

#echo "Motherboard: `dmidecode -s baseboard-manufacturer` / `dmidecode -s baseboard-product-name` / `dmidecode -s baseboard-version`" >> $file



manufacturer=`dmidecode -s baseboard-manufacturer`
manufacturer="`echo $manufacturer | sed 's/^0\?$/Unknown/'`"

productName=`dmidecode -s baseboard-product-name`
productName="`echo $productName | sed 's/^0\?$/Unknown/'`"

if [ "$manufacturer" = "Unknown" ] && [ $productName != "Unknown" ]; then
echo "Motherboard: $productName" >> $file
elif [ "$manufacturer" = "Unknown" ] && [ $productName = "Unknown" ]; then
echo "Motherboard: Unknown" >> $file
else
echo "Motherboard: $manufacturer $productName" >> $file
fi


serialNumber=`dmidecode -s system-serial-number | sed 's/^0\?$/Unknown/'`
echo "System Serial Number: $serialNumber" >> $file


#Systeam:
echo "--- System ---" >> $file

os=$(lsb_release -a 2>/dev/null |grep Description: | awk -F ":" '{print $2}')
echo "OS Distribution:" $os >> $file
#cat /etc/*release*
#cat /etc/issue
#cat /etc/*version*

echo "Kernel version: `uname -r`" >> $file

echo "Installation date: `ls -ctl --time-style=long-iso / | tail -n 1 | awk '{ print $6 }'`" >> $file

echo "Hostname: `hostname`" >> $file

echo "Uptime: `uptime -p | awk -F "up " '{print $2}'`" >> $file

echo "Processes running: `ps | awk '/ps/ {print $1}'`" >> $file

#echo "User logged in: `cat /etc/passwd | wc -l`" >> $file
echo "User logged in: `who | wc -l`" >> $file


#Network:
echo "--- Network ---" >> $file

i=1;
for var in $(ip add show | awk '/^[0-9]: /{print $2}' | awk -F ":" '{print $1}')
do
if ip add show $var | grep -q "inet"
then
interface=`ip add show $var | grep "inet " | awk '{print $2}'`
interface=`echo $interface | sed 's/\s/, /g'`
echo "<Iface #$i $var>: $interface" >> $file 
else
echo "<Iface #$i $var>: -" >> $file
fi
let i=i+1
done 

#mapfile -d $':' -t strings < <(ip addr show)x
#echo ${strings[0]}






































