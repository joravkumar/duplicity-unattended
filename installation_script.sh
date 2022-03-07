#!/bin/bash  
echo "Enter the email of User: "  
read EMAIL

apt update -y
apt upgrade -y
apt install python3-pip -y
apt install pipenv -y 
pipenv install
pipenv shell
apt install duplicity -y 
apt install python-yaml -y
apt install gnupg -y
echo "Generating GPG ID. Do NOT set a passphrase"
gpg --full-generate-key --pinentry loopback # Do NOT set a passphrase
gpg --armor --output pubkey.gpg --export $EMAIL
gpg --armor --output privkey.gpg --export-secret-key $EMAIL
mkdir /etc/duplicity-unattended
cp config.yaml /etc/duplicity-unattended/
cp duplicity-unattended /usr/bin/
chmod +x /usr/bin/duplicity-unattended
duplicity-unattended --config /etc/duplicity-unattended/config.yaml --dry-run
cp systemd/duplicity-unattended.service /etc/systemd/system
cp systemd/duplicity-unattended.timer /etc/systemd/system
systemctl daemon-reload
systemctl enable duplicity-unattended.timer
systemctl start duplicity-unattended.timer
systemctl start duplicity-unattended.service