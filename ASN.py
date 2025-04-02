import asyncio

async def generate_asn_numbers(start, end):
    asn_numbers = []
    for number in range(start, end + 1):
        # Simulasi operasi asinkron (misalnya, I/O)
        await asyncio.sleep(0)  # Ini hanya untuk menunjukkan bahwa kita bisa melakukan operasi asinkron
        asn_numbers.append(f"AS{number}")
    return asn_numbers

async def main():
    # Meminta input dari pengguna
    input_range = input("Masukkan angka (misal: 56789 - 89262): ")
    
    # Memisahkan angka mulai dan angka akhir
    try:
        start_str, end_str = input_range.split('-')
        start = int(start_str.strip())
        end = int(end_str.strip())
        
        # Menghasilkan ASN numbers
        asn_numbers = await generate_asn_numbers(start, end)
        
        # Menampilkan hasil
        print("Hasil ASN:")
        for asn in asn_numbers:
            print(asn)
        
        # Menyimpan hasil ke dalam file
        with open("asn_numbers.txt", "w") as file:
            for asn in asn_numbers:
                file.write(asn + "\n")
        
        print("Hasil ASN telah disimpan ke dalam file 'asn_numbers.txt'.")
    
    except ValueError:
        print("Input tidak valid. Pastikan formatnya benar (misal: 56789 - 89262).")

if __name__ == "__main__":  # Perbaikan di sini
    asyncio.run(main())
