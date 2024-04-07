#!/bin/bash
#
# run_client.sh
#
# A bash script for running OpenSSL demonstration client to get a web page from the OpenSSL
# demonstration server, using the ETSI QKD API for QKD key agreement. The output of the client is
# written to client.out.
# 
# (c) 2019 Bruno Rijsman, All Rights Reserved.
# See LICENSE for licensing information.
#

# Function to handle errors
handle_error() {
    echo "Error: $1" >&2
    exit 1
}

# Function to run the client
run_client() {
    local server_address="$1"
    local server_port="$2"
    
    echo "Running client..."

    # Remove existing output file
    rm -f client.out

    # Log start time
    echo "Client started on $(date +'%Y-%m-%dT%H:%M:%S.%s')" > client.out

    # Set OpenSSL configuration
    export OPENSSL_CONF=client_openssl.cnf

    # Construct HTTP GET request
    local request="GET /"

    # Run OpenSSL client
    echo "$request" | \
        ${OPENSSL_BIN}/openssl s_client \
        -tls1_2 \
        -cipher 'DHE-RSA-AES128-GCM-SHA256' \
        -connect "$server_address:$server_port" \
        -CAfile cert.pem \
        -msg \
        >> client.out 2>&1
}

# Function to run the client is ended here 
# Main entry point
main() {
    # Set platform-dependent variables
    source set_platform_dependent_variables.sh || handle_error "Failed to set platform-dependent variables"

    # Run client with server address and port
    run_client "localhost" "44330"

    # Check exit status
    if [[ $? -eq 0 ]]; then
        echo "Client operation completed successfully."
    else
        echo "Client operation failed."
    fi
}

# Execute main function
main
