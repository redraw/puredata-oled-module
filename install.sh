#!/bin/sh

SOFTWARE_TO_INSTALL="puredata pisound-ctl amidiauto pisound-ctl-scripts-puredata"
OLED_DEPS="python3-dev python3-pip libfreetype6-dev libjpeg-dev build-essential libopenjp2-7 libtiff5"

sudo apt-get update
sudo apt-get install $SOFTWARE_TO_INSTALL $OLED_DEPS -y

echo "Downloading OLED OSC + Organelle patches"
git clone --recurse-submodules https://github.com/redraw/flagellum /tmp/flagellum

mkdir -p /home/patch/Pd/{patches,externals}

cp -rv /tmp/flagellum/pd/externals /home/patch/Pd/externals
cp -rv {/tmp/flagellum/pd,/home/patch/Pd}/patches/organelle
cp -rv /tmp/flagellum/mother.pd /home/patch/Pd/patches/organelle/mother.pd
cp -rv /tmp/flagellum/oled /usr/local/oled
rm -rf /tmp/flagellum

echo "Installing OLED requirements"
sudo pip3 install -r /usr/local/oled/requirements.txt

echo "Installing systemd oled.service"
sudo cp -f /usr/local/oled/oled.service /usr/lib/systemd/system/oled.service
sudo systemctl daemon-reload
sudo systemctl enable oled

echo "Enabling I2C"
sed -i '/dtparam=i2c/c\dtparam=i2c_arm=on,i2c_arm_baudrate=400000' /boot/config.txt

echo "Done! Thank you!"
