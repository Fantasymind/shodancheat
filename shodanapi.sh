#!/bin/bash

# Fungsi untuk melakukan lookup IP
lookup_ip() {
    local ip=$1
    curl -s "https://internetdb.shodan.io/$ip"
}

# Cek apakah file.txt ada
if [ -f "file.txt" ]; then
    # Jika file.txt ada, baca dari file
    while IFS= read -r ip; do
        lookup_ip "$ip" &  # Jalankan lookup di latar belakang
    done < "file.txt"
else
    # Jika tidak ada file.txt, cek argumen
    if [ "$#" -eq 1 ]; then
        ip=$1
        lookup_ip "$ip" &  # Jalankan lookup di latar belakang
    else
        echo "Silakan berikan IP sebagai argumen atau pastikan file.txt ada."
        exit 1
    fi
fi

# Tunggu semua proses latar belakang selesai
wait
