#!/usr/bin/env bash


. "$(dirname $0)/conf/config"
. "$(dirname $0)/conf/functions"

download_cross_signed

for f in cert/*; do
	domain=$(basename $f)
    #TODO - detect failed renew and process
	python $acme --account-key $account_key --csr "${csr_dir}/${domain}" --acme-dir "${challenge_dir}" > "${cert_dir=}/${domain}"
	setup_httpd $domain $web_server

done;

if [ $web_server == "apache" ]; then
    systemctl reload httpd
else
    systemctl reload nginx
fi;

