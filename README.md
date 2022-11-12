# Root CA, Intermediate CA and Server Certificate using OpenSSL
Root CA, Intermediate CA, Server Certificate Generation Using OpenSSL.

Pull the repository directory and open the files `intermCA.cnf` and `rootCA.cnf` and change the `DOMAIN_NAME` to your desired domain. Open `/etc/ssl/ssl_certs/config/csr.cnf` and set FQDN[1-3] to your desired domain and save it. 

## Create directories and move to `/etc/ssl/`
```bash
sh make_dirs.sh
```

## Root CA generation
Generating Private Key for Root CA and Signing the Root Certificate

```bash
sh rootCA_generator.sh
```

Enter the domain name when asked ad wait for certificate generation to be completed.

## Intermediate CA generation
Generating the Private Key and Certificate Signing Request (CSR) for the Intermediate CA, Generating the Intermediate CA and Creating Certificate Chain

```bash
sh intermCA_generator.sh
```

Enter the domain name when asked ad wait for certificate generation to be completed.

## Creating Server Certificate

Creating the Private Key and CSR and Creating the Server Certificate by signing the CSR with the Intermediate CA

```bash
sh serverCert_generator.sh
```

Enter the Full-Qualified Domain Name (FQDN) when asked ad wait for certificate generation to be completed.
