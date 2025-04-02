#!/bin/bash

# Check if the input file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

# Input file containing the list of IPs or hostnames
input_file="$1"

# Temporary file to store ASN results
asn_results="asn_results.txt"

# Clear the temporary file
> "$asn_results"

# Function to perform the Nmap scan
scan_target() {
    local target="$1"
    echo "Scanning target: $target"
    
    # Run the Nmap command to get ASN information
    nmap --script targets-asn --script-args targets-asn.asn="$target" | tee -a "$asn_results"
    
    # Optionally, you can extract the ASN from the output and perform further actions
    asn=$(grep -oP '(\d+)' "$asn_results" | tail -n 1)  # Get the last ASN found

    if [ -n "$asn" ]; then
        echo "Found ASN: $asn for target: $target"
        # Here you can add additional commands to scan the prefix associated with the ASN
        # For example, you can use whois to find the prefix and scan it
        # whois_output=$(whois "$asn")  # Uncomment this line to get whois output
        # Extract the prefix from whois_output and scan it (this part needs to be implemented)
    else
        echo "No ASN found for target: $target"
    fi
}

# Maximum number of concurrent jobs
max_jobs=25
job_count=0

# Loop through each line in the input file
while IFS= read -r target; do
    scan_target "$target" &  # Call the function to scan the target in the background
    ((job_count++))

    # If the number of concurrent jobs reaches the limit, wait for them to finish
    if (( job_count >= max_jobs )); then
        wait  # Wait for all background jobs to finish
        job_count=0  # Reset the job count
    fi
done < "$input_file"

# Wait for any remaining background jobs to finish
wait

echo "Scanning complete. ASN results saved in $asn_results."
