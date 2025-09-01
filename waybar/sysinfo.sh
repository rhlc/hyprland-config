#!/bin/bash
cpu=$(grep 'cpu ' /proc/stat | awk '{print ($2+$4)*100/($2+$4+$5)}' | cut -d. -f1)
mem=$(free | awk '/Mem/ {printf "%.0f", $3/$2 * 100}')
temp=$(cat /sys/class/hwmon/hwmon6/temp1_input | cut -c-2)
echo "{\"text\": \"$cpu | $mem | $temp°\"}"

# echo "{\"text\": \" $cpu    $mem    $temp°\"}"

