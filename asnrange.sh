#!/bin/bash

# Memeriksa apakah argumen diberikan
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <file_with_cidrs>"
    exit 1
fi

FILE=$1

# Memeriksa apakah file ada
if [ ! -f "$FILE" ]; then
    echo "File not found!"
    exit 1
fi

# Fungsi untuk mengonversi IP ke long
IP2LONG() {
    local a b c d
    IFS='.' read -r a b c d <<< "$1"
    echo $(( (a << 24) + (b << 16) + (c << 8) + d ))
}

# Fungsi untuk mengonversi long ke IP
LONG2IP() {
    local num=$1
    echo "$(( (num >> 24) & 255 )).$(( (num >> 16) & 255 )).$(( (num >> 8) & 255 )).$(( num & 255 ))"
}

# Fungsi untuk mencetak rentang IP
print_ip_range() {
    local CIDR=$1
    # Mengambil alamat IP dan prefix
    IFS='/' read -r IP PREFIX <<< "$CIDR"

    # Menghitung jumlah alamat IP dalam rentang
    START=$(IP2LONG "$IP")
    NETMASK=$(( 0xFFFFFFFF << (32 - PREFIX) ))
    FIRST=$(( START & NETMASK ))
    LAST=$(( FIRST | ~NETMASK & 0xFFFFFFFF ))

    # Mencetak semua alamat IP dalam rentang
    for (( i=FIRST; i<=LAST; i++ )); do
        LONG2IP $i
    done
}

# Membaca setiap baris dari file
while IFS= read -r CIDR; do
    print_ip_range "$CIDR" &  # Menjalankan fungsi di latar belakang
done < "$FILE"

# Menunggu semua proses latar belakang selesai
wait
