#!/usr/bin/env bash


. "$(dirname $0)/conf/config"
. "$(dirname $0)/conf/functions"

mode="${default_mode}"

if [ $1 == "-nginx" ]; then
    mode="nginx"
    shift 1
elif [ $1 == "-apache" ]; then
    mode="apache"
    shift 1
fi

download_cross_signed

for f in cert/*; do
	domain=$(basename $f)
    #TODO - detect failed renew and process
	python $acme --account-key $account_key --csr "${csr_dir}/${domain}" --acme-dir "${challenge_dir}" > "${cert_dir=}/${domain}"
	setup_httpd $domain $mode

done;

systemctl reload httpd


