# Root CA and Intermediate CA using OpenSSL
Root CA and Intermediate CA generation using OpenSSL.

## Create directories and conifugrations
```bash
cd /etc/ssl/
mkdir ssl_certs
mkdir config rootCA intermCA server_cert cert_chain
cd /etc/ssl/ssl_certs/config
```
Pull the repository inside the `config` directory and open the files `csr.cnf`, `intermCA.cnf` and `rootCA.cnf` and change the `DOMAIN_NAME` to your desired domain.

## Root CA generation

### Create the directory structure for the Root CA
Create directories `newcerts`, `certs`, `crl`, `private` and `requests` inside the `rootCA` and create `index.txt` file for OpenSSL to keep track of all signed certificates and the `serial` file to give the start point for each signed certificate’s serial number. This can be accomplished by doing the following:

```bash
cd /etc/ssl/ssl_certs/rootCA
mkdir newcerts certs crl private requests
touch index.txt
touch index.txt.attr
echo '1000' > serial
```

### Generating private key for RootCA

```bash
openssl genrsa -out /etc/ssl/ssl_certs/rootCA/private/ca.DOMAIN_NAME.key.pem 4096
```

### Signing the Root Certificate

```bash
openssl req -config /etc/ssl/ssl_certs/config/rootCA.cnf -new -x509 -sha512 -extensions v3_ca -key /etc/ssl/ssl_certs/rootCA/private/ca.DOMAIN_NAME.key.pem -out /etc/ssl/ssl_certs/rootCA/certs/ca.DOMAIN_NAME.crt.pem -days 3650 -set_serial 0
```

## Intermediate CA generation

### Create the directory structure for the intermediate CA
Create directories `newcerts`, `certs`, `crl`, `csr` and `private` inside the `intermCA` and create `index.txt` file for OpenSSL to keep track of all signed certificates, the `serial` file to give the start point for each signed certificate’s serial number, `crlnumber` for certificate revocation lists. This can be accomplished by doing the following:

```bash
cd /etc/ssl/ssl_certs/intermCA
mkdir newcerts certs crl csr private
touch index.txt
touch index.txt.attr
echo 1000 > crlnumber
echo '1234' > serial
```

### Generating the private key and certificate signing request (CSR) for the Intermediate CA

```bash
cd /etc/ssl/ssl_certs/intermCA
openssl req -config /etc/ssl/ssl_certs/config/intermeCA.cnf -new -newkey rsa:4096 -keyout /etc/ssl/ssl_certs/intermCA/private/int.DOMAINNAME.key.pem -out /etc/ssl/ssl_certs/intermCA/csr/int.DOMAINNAME.csr
```

### Generating the Intermediate CA

```bash
openssl ca -config /etc/ssl/ssl_certs/config/rootCA.cnf -extensions v3_intermediate_ca -days 3650 -notext -md sha512 -in /etc/ssl/ssl_certs/intermCA/csr/int.DOMAINNAME.csr -out /etc/ssl/ssl_certs/intermCA/certs/int.DOMAINNAME.crt.pem
```

## Creating the certificate chain

```bash
cd /etc/ssl/ssl_certs/
cat intermCA/certs/int.DOMAINNAME.crt.pem root/certs/ca.DOMAINNAME.crt.pem > cert_chain/chain.DOMAINNAME.crt.pem
```

## Creating server certificates

### Creating the private key and CSR

```bash
cd /etc/ssl/ssl_certs/server_cert
openssl req -out /etc/ssl/ssl_certs/server_cert/csr/FQDN.csr.pem -newkey rsa:2048 -nodes -keyout /etc/ssl/ssl_certs/server_cert/private/FQDN.key.pem -config /etc/ssl/ssl_certs/config/csr.cnf
```

### Creating the server certificate by signing the CSR with the Intermediate CA

```bash
openssl ca -config /etc/ssl/ssl_certs/config/intermCA.cnf -extensions server_cert -days 3750 -notext -md sha512 -in /etc/ssl/ssl_certs/server_cert/csr/FQDN.csr.pem -out /etc/ssl/ssl_certs/server_cert/certs/FQDN.crt.pem
```

