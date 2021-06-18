#!/bin/bash -e

install -v -m 655 files/config.yaml "${ROOTFS_DIR}/"
install -v -m 655 files/settings.json "${ROOTFS_DIR}/"
install -v -m 655 files/ms-python.vscode-pylance-2020.12.2.vsix "${ROOTFS_DIR}/"
install -v -m 655 files/ms-python-release.vsix "${ROOTFS_DIR}/"

on_chroot << EOF
su pythonic -c "curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -"
apt-get install -y nodejs

su pythonic -c "curl -fsSL https://code-server.dev/install.sh | sh"

mkdir -p /home/pythonic/.config/code-server
mkdir -p /home/pythonic/.local/share/code-server
mkdir -p /home/pythonic/extension

chown -R pythonic:pythonic /home/pythonic/.config
chown -R pythonic:pythonic /home/pythonic/.local
chown -R pythonic:pythonic /home/pythonic/extension


mv config.yaml /home/pythonic/.config/code-server/
mv settings.json /home/pythonic/.local/share/code-server/

chown pythonic:pythonic /home/pythonic/.config/code-server/config.yaml
chown pythonic:pythonic /home/pythonic/.local/share/code-server/settings.json



(cd /home/pythonic/extension; bsdtar -xvf /ms-python-release.vsix)
(cd /home/pythonic/extension; mv extension ms-python.python-vscode-2.0.3)

(cd /home/pythonic/extension; bsdtar -xvf /ms-python.vscode-pylance-2020.12.2.vsix)
(cd /home/pythonic/extension; mv extension ms-python.vscode-pylance-2020.12.2)

(cd /home/pythonic/extension; rm \[Content_Types\].xml)
(cd /home/pythonic/extension; rm extension.vsixmanifest)
EOF
