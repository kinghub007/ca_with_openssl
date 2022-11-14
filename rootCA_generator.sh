#!/bin/bash

mkdir -p /etc/ssl/ssl_certs/rootCA/newcerts/
mkdir -p /etc/ssl/ssl_certs/rootCA/certs/
mkdir -p /etc/ssl/ssl_certs/rootCA/crl/
mkdir -p /etc/ssl/ssl_certs/rootCA/private/
mkdir -p /etc/ssl/ssl_certs/rootCA/requests

touch /etc/ssl/ssl_certs/rootCA/index.txt
touch /etc/ssl/ssl_certs/rootCA/index.txt.attr
echo '1000' > /etc/ssl/ssl_certs/rootCA/serial

file=/etc/ssl/ssl_certs/rootCA/serial
while IFS= read -r num1
do
	num=$(( $num1 + 1 ))
	echo $num > /etc/ssl/ssl_certs/rootCA/serial
done < "$file"

## Generating private key for RootCA

read -p "Enter the domain name: " DOMAIN_NAME
/usr/bin/openssl genrsa -out /etc/ssl/ssl_certs/rootCA/private/ca."$DOMAIN_NAME".key.pem 4096


## Signing the Root Certificate

/usr/bin/openssl req -config /etc/ssl/ssl_certs/config/rootCA.cnf -new -x509 -sha512 -extensions v3_ca -key /etc/ssl/ssl_certs/rootCA/private/ca."$DOMAIN_NAME".key.pem -out /etc/ssl/ssl_certs/rootCA/certs/ca."$DOMAIN_NAME".crt.pem -days 3650 -set_serial 0

## Generating dhparam
/usr/bin/openssl dhparam -out /etc/ssl/ssl_certs/dhparam.pem 2048
