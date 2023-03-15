#!/bin/sh 
# installation et initialisation d'ubuntu server 
# pour avoir un gui et pouvoir utiliser vnc
########################################################

user="ubuntu"
passwd="ubuntu"

sudo apt update -y
sudo apt dist-upgrade -y
sudo apt install xfce4 xfce4-goodies -y
sudo apt install tightvncserver -y

#vncserver
#vncserver -kill :1
                               