#!/usr/bin/env bash

. "$(dirname $0)/conf/config"
. "$(dirname $0)/conf/functions"

if [ $# -lt 1 ]
then
    echo "No domain name specified"
    echo "Usage: ${0} domain-name"
    exit
fi

domain=$1

if [ ! -f "key/${domain}" ]; then

    # generate domain key
    openssl genrsa 4096 > "${key_dir}/${domain}"

    # create CSR (if 2nd level domain, add version with www)
    # detection is base simply on dot count in domain
    dot_count=$(echo $domain | grep -o "\." | wc -l)

    if [ $dot_count -ne 1 ]; then
     	openssl req -new -sha256 -key "${key_dir}/${domain}" \
	     -subj "/CN=${domain}" \
	     > "${csr_dir}/${domain}"
 
     else
	openssl req -new -sha256 -key "${key_dir}/${domain}" \
	     -subj "/" \
	     -reqexts SAN \
	     -config <(cat $ssl_conf <(printf "[SAN]\nsubjectAltName=DNS:${domain},DNS:www.${domain}")) \
	     > "${csr_dir}/${domain}"
    fi


    python $acme --account-key ${account_key} \
        --csr "${csr_dir}/${domain}" \
        --acme-dir "${challenge_dir}" \
        > "${cert_dir}/${domain}"


    setup_httpd $domain

    #systemctl reload httpd

else
    echo "Domain file for ${domain} already exists"
    exit
fi
