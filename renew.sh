#!/usr/bin/env bash


. "$(dirname $0)/conf/config"
. "$(dirname $0)/conf/functions"

wget -O - https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem > /etc/pki/tls/certs/le-cross-signed.pem

for f in cert/*; do
	domain=$(basename $f)
	python $acme --account-key $account_key --csr "${csr_dir}/${domain}" --acme-dir "${challenge_dir}" > "${cert_dir=}/${domain}" || exit
	setup_httpd $domain

done;

systemctl reload httpd


