#!/bin/bash -e

# Enable mosquitto service

on_chroot << EOF
systemctl enable mosquitto.service
EOF

# Install PM2 and enable service, run as user pi

install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/.pm2"
install -v -o 1000 -g 1000 files/dump.pm2 "$ROOTFS_DIR/home/pi/.pm2/dump.pm2"
install -m 444 files/pm2-pi.service "$ROOTFS_DIR/etc/systemd/system/pm2-pi.service"

# Update npm
on_chroot << EOF
npm install -g  --unsafe-perm npm@latest
EOF

on_chroot << EOF
npm install -g --unsafe-perm --no-progress pm2

systemctl daemon-reload
systemctl enable pm2-pi.service
EOF

# Install Node-RED
on_chroot << EOF
npm install -g --unsafe-perm --no-progres node-red

npm install -g --unsafe-perm --ignore-scripts node-red-dashboard
EOF

install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/.node-red"
install -v -o 1000 -g 1000 files/flows_hub.json "$ROOTFS_DIR/home/pi/.node-red/flows_hub.json"

# Update pip3
on_chroot << EOF
pip3 --version
pip3 install --upgrade pip
EOF

# Install BigClown Firmware Tool
on_chroot << EOF
pip3 install --upgrade bcf
EOF

# Install BigClown Gateway
on_chroot << EOF
pip3 install --upgrade bcg
EOF

# Install BigClown Control tool
on_chroot << EOF
pip3 install --upgrade bch
EOF

install -m 644 files/bash_completion.d/* "$ROOTFS_DIR"/etc/bash_completion.d/
install -m 755 files/update-motd.d/* "$ROOTFS_DIR"/etc/update-motd.d/
