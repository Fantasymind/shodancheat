import nmap3
import requests
import argparse

def get_cidr_from_asn(asn):
    """Mengambil rentang CIDR dari ASN menggunakan API."""
    try:
        response = requests.get(f'https://api.ip2asn.com/v1/ranges/{asn}')
        data = response.json()
        if 'ranges' in data:
            return [range['prefix'] for range in data['ranges']]
        else:
            print(f'Tidak ada rentang ditemukan untuk {asn}.')
            return []
    except Exception as e:
        print(f'Error saat mengambil CIDR untuk {asn}: {e}')
        return []

def scan_cidr(cidr):
    """Melakukan pemindaian pada rentang CIDR menggunakan Nmap."""
    nm = nmap.PortScanner()
    print(f'Memindai CIDR: {cidr}')
    nm.scan(hosts=cidr, arguments='-sn')  # Menggunakan -sn untuk pemindaian ping
    return nm.all_hosts()

def main(input_file, output_file):
    # Membaca daftar ASN dari file
    try:
        with open(input_file, 'r') as file:
            asn_list = file.readlines()

        # Menghapus whitespace dan newline
        asn_list = [asn.strip() for asn in asn_list if asn.strip()]

        with open(output_file, 'w') as output_file:
            for asn in asn_list:
                print(f'Mencari CIDR untuk {asn}...')
                cidr_list = get_cidr_from_asn(asn)

                for cidr in cidr_list:
                    hosts = scan_cidr(cidr)
                    output_file.write(f'Hasil pemindaian untuk {cidr}: {hosts}\n')

    except FileNotFoundError:
        print(f"File {input_file} tidak ditemukan!")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Scan ASN and save results to a file.')
    parser.add_argument('-f', '--file', required=True, help='File yang berisi daftar ASN')
    parser.add_argument('-o', '--output', required=True, help='File untuk menyimpan hasil pemindaian')

    args = parser.parse_args()
    main(args.file, args.output)
