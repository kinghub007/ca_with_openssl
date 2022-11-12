#!/bin/sh

mkdir -p /etc/ssl/ssl_certs/server_cert/certs
mkdir -p /etc/ssl/ssl_certs/server_cert/csr
mkdir -p /etc/ssl/ssl_certs/server_cert/private

read -p "Enter FQDN: " FQDN
/usr/bin/openssl req -out /etc/ssl/ssl_certs/server_cert/csr/"$FQDN".csr.pem -newkey rsa:2048 -nodes -keyout /etc/ssl/ssl_certs/server_cert/private/"$FQDN".key.pem -config /etc/ssl/ssl_certs/config/csr.cnf
