#!/bin/bash

mkdir -p /etc/ssl/ssl_certs/intermCA/newcerts/
mkdir -p /etc/ssl/ssl_certs/intermCA/certs/
mkdir -p /etc/ssl/ssl_certs/intermCA/crl/
mkdir -p /etc/ssl/ssl_certs/intermCA/csr/
mkdir -p /etc/ssl/ssl_certs/intermCA/private/

touch /etc/ssl/ssl_certs/intermCA/index.txt
touch /etc/ssl/ssl_certs/intermCA/index.txt.attr
echo '1000' > /etc/ssl/ssl_certs/intermCA/crlnumber
echo '1234' > /etc/ssl/ssl_certs/intermCA/serial

##  Generating the private key and certificate signing request (CSR) for the Intermediate CA
read -p "Enter the domain name: " DOMAIN_NAME
/usr/bin/openssl req -config /etc/ssl/ssl_certs/config/intermCA.cnf -new -newkey rsa:4096 -keyout /etc/ssl/ssl_certs/intermCA/private/int."$DOMAIN_NAME".key.pem -out /etc/ssl/ssl_certs/intermCA/csr/int."$DOMAIN_NAME".csr

## Generating the Intermediate CA
/usr/bin/openssl ca -config /etc/ssl/ssl_certs/config/rootCA.cnf -extensions v3_intermediate_ca -days 3650 -notext -md sha512 -in /etc/ssl/ssl_certs/intermCA/csr/int."$DOMAIN_NAME".csr -out /etc/ssl/ssl_certs/intermCA/certs/int."$DOMAIN_NAME".crt.pem

## Creating the certificate chain
cat /etc/ssl/ssl_certs/intermCA/certs/int."$DOMAIN_NAME".crt.pem /etc/ssl/ssl_certs/rootCA/certs/ca."$DOMAIN_NAME".crt.pem > /etc/ssl/ssl_certs/cert_chain/chain."$DOMAIN_NAME".crt.pem
