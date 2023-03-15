#!/bin/sh 
# initialisation du daemon et mise en place du service
#
########################################################

user="ubuntu"
passwd="ubuntu"

mkdir /home/$user/.vnc
touch /home/$user/.vnc/passwd
chown -R $user:$user /home/$user/.vnc  

echo $passwd | vncpasswd -f > /home/$user/.vnc/passwd

chmod 0600 /home/$user/.vnc/passwd

cp /home/ubuntu/xstartup /home/ubuntu/.vnc/xstartup
chmod +x /home/ubuntu/.vnc/xstartup
sudo cp /home/ubuntu/daemon /etc/systemd/system/vncserver@.service

sudo systemctl daemon-reload
sudo systemctl enable vncserver@1.service
#vncserver -kill :1
sudo systemctl start vncserver@1                          