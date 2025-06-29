#!/usr/bin/env bash

# Warna untuk tampilan
GREEN='\033[0;32m'
NC='\033[0m'

# Tanyakan domain saat script dijalankan
read -p "Masukkan domain panel kamu (contoh: panel.domainmu.com): " DOMAIN

echo -e "${GREEN}[+] Domain yang digunakan: $DOMAIN${NC}"

# Cek dan install 'expect' jika belum ada
if ! command -v expect &> /dev/null; then
    echo -e "${GREEN}[+] Installing expect...${NC}"
    apt update && apt install -y expect
fi

# Download script installer ke file sementara
INSTALLER_SCRIPT="/tmp/ptero_installer.sh"
curl -sSL https://pterodactyl-installer.se -o "$INSTALLER_SCRIPT"
chmod +x "$INSTALLER_SCRIPT"

# Jalankan script installer menggunakan expect
expect <<EOF
set timeout -1
spawn bash "$INSTALLER_SCRIPT"

expect {
    "*Masukkan Nama Anda*" {
        send "AXEL\r"
        exp_continue
    }
    "*Masukkan Username Panel*" {
        send "AXEL\r"
        exp_continue
    }
    "*Masukkan Nama Panel*" {
        send "AXEL\r"
        exp_continue
    }
    "*Masukkan Domain Anda*" {
        send "$DOMAIN\r"
        exp_continue
    }
    "*Masukkan Alamat Email*" {
        send "Dst\r"
        exp_continue
    }
    "*Apakah Anda yakin*" {
        send "y\r"
        exp_continue
    }
    "*Y/n*" {
        send "y\r"
        exp_continue
    }
    eof
}
EOF

echo -e "${GREEN}[✓] Instalasi Pterodactyl selesai menggunakan domain: $DOMAIN${NC}"
