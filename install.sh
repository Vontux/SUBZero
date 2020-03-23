#!/bin/bash
sudo apt update && sudo apt upgrade
sudo apt install -y hostapd dnsmasq
sudo apt install -y uuid-runtime
sudo apt install -y python3-pip
sudo apt install -y python3-pil
sudo pip3 install adafruit-circuitpython-ssd1306
sudo mkdir -p /var/www/SUBZero/ && sudo cp ./httpsServer.py /var/www/SUBZero && sudo cp wallpaper.jpg /var/www/SUBZero &&  openssl req -new -x509 -keyout server.pem -out server.pem -days 365 -nodes && sudo cp ./server.pem /var/www/SUBZero
 
chmod +x ./subzero.sh && sudo cp ./subzero.sh /usr/local/bin
(sudo crontab -l 2>/dev/null; echo "@reboot /usr/local/bin/subzero.sh") | crontab -
(sudo crontab -l 2>/dev/null; echo "*/5 * * * * /home/pi/SUBZero/runscreen.sh") | crontab -
sudo chmod +x ./runscreen.sh
sudo cp ./poweroff.service /etc/systemd/system/poweroff.service
sudo mv /etc/dhcpcd.conf /etc/dhcpcd.bak
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.bak
sudo mv /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.bak
sudo mv /etc/network/interfaces /etc/network/interfaces.bak

sudo cp ./interfaces /etc/network/
sudo cp ./dhcpcd.conf /etc/
sudo cp ./dnsmasq.conf /etc/
randi=$(uuidgen | md5sum)
randi=${randi::-17}
orig=$(grep wpa_passphrase ./hostapd.conf | sed 's/.*=//')
sed -i "s/$orig/$randi/g" ./hostapd.conf
sudo cp ./hostapd.conf /etc/hostapd/
echo "DAEMON_CONF=\"/etc/hostapd/hostapd.conf\"" | sudo tee -a /etc/default/hostapd
sudo systemctl unmask hostapd
sudo ldconfig
sudo systemctl enable hostapd
sudo systemctl start hostapd
sudo systemctl enable dnsmasq
