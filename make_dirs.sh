#!/bin/bash

mkdir -p ./ssl_certs/config
mkdir -p ./ssl_certs/cert_chain

cp ./csr.cnf ./intermCA.cnf ./rootCA.cnf ./ssl_certs/config/

mv ./ssl_certs /etc/ssl/
