#!/bin/sh

mkdir -p /etc/ssl/ssl_certs/server_cert/certs
mkdir -p /etc/ssl/ssl_certs/server_cert/csr
mkdir -p /etc/ssl/ssl_certs/server_cert/private

read -p "Enter FQDN: " FQDN
/usr/bin/openssl req -out /etc/ssl/ssl_certs/server_cert/csr/"$FQDN".csr.pem -newkey rsa:2048 -nodes -keyout /etc/ssl/ssl_certs/server_cert/private/"$FQDN".key.pem -config /etc/ssl/ssl_certs/config/csr.cnf

/usr/bin/openssl ca -config /etc/ssl/ssl_certs/config/intermCA.cnf -extensions server_cert -days 3750 -notext -md sha512 -in /etc/ssl/ssl_certs/server_cert/csr/"$FQDN".csr.pem -out /etc/ssl/ssl_certs/server_cert/certs/"$FQDN".crt.pem
