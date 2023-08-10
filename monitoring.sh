#!/bin/bash
#---------------------------------------------------------------------------------------
#architecture du systeme d'exploitation
ARCHI=$(uname -a)
echo -n -e "\t#Architecture : $ARCHI\n" > monitoring.txt
#---------------------------------------------------------------------------------------
#nombre de processeurs physiques.
echo -n -e "\t#CPU physical : " >> monitoring.txt
lscpu | grep "par socket" | awk '{print $4}' >> monitoring.txt
#---------------------------------------------------------------------------------------
#nombre de processeurs virtuels.
echo -n -e "\t#vCPU : " >> monitoring.txt
lscpu | grep "Thread" | awk '{print $4}' >> monitoring.txt
#---------------------------------------------------------------------------------------
#Memoir vivre disponible
echo -n -e "\t#Memory Usage : " >> monitoring.txt
free -m | grep "Mem" | awk '{printf $3}' >> monitoring.txt
echo -n -e "/" >> monitoring.txt
free -m | grep "Mem" | awk '{printf $2}' >> monitoring.txt
echo -n -e "MB (" >> monitoring.txt
free | grep "Mem" | awk '{printf "%.2f", $3 / $2 * 100}' >> monitoring.txt
echo "%)" >> monitoring.txt
#---------------------------------------------------------------------------------------
#Memoir disponible
USER=$(df -P | awk 'NR > 1 {value += $3} END {printf "%.2f", value / (1024 * 1024)}')
TOTAL=$(df -P | awk 'NR > 1 {value += $2} END {printf "%.2f", value / (1024 * 1024)}')
echo -n -e "\t#Disk Usage : $USER/$TOTAL Gb (" >> monitoring.txt
echo "$USER $TOTAL" | awk '{printf "%.2f", $1 / $2 * 100}' >> monitoring.txt
echo "%)" >> monitoring.txt
#---------------------------------------------------------------------------------------
#taux d'utilisation actuel du processeur
CPU=$(top -n1 -b | sed -n 3p | awk '{print $2}')
echo -n -e "\t#CPU load : $CPU%" >> monitoring.txt
#---------------------------------------------------------------------------------------
#date et heure du dernier redemarrage
who -b | awk '{print "\n\t#Last boot : " $3 " " $4}' >> monitoring.txt
#---------------------------------------------------------------------------------------
#voir si LVM est actif
echo -n -e "\t#LVM use : " >> monitoring.txt
lsblk | grep "lvm" | grep "/" | wc -l | awk '{if ($1 < 0) print "no"; else print "yes"}' >> monitoring.txt
#---------------------------------------------------------------------------------------
#nombre de connection actives
echo -n -e "\t#Connexions TCP : " >> monitoring.txt
TCP=$(netstat -ant | grep "ESTA" | wc -l)
echo "$TCP ESTABLISHED" >> monitoring.txt
#---------------------------------------------------------------------------------------
#nombre d'utilisateurs utilisant le serveur
echo -n -e "\t#User log : " >> monitoring.txt
who | wc -l >> monitoring.txt
#---------------------------------------------------------------------------------------
#adresse IP et adresse MAP
echo -n -e "\t#Network : IP " >> monitoring.txt
IP=$(hostname -I)
MAC=$(ip addr show | grep "ether" | awk '{printf $2}')
echo "$IP ($MAC)" >> monitoring.txt
#---------------------------------------------------------------------------------------
#nombre de commande executées par sudo
echo -n -e "\t#Sudo : " >> monitoring.txt
CMD=$(cat /var/log/sudo/seq)
echo -n $((36#$CMD)) >> monitoring.txt
echo " cmd" >> monitoring.txt
#---------------------------------------------------------------------------------------
wall monitoring.txt

