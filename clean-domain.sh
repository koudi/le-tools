#!/usr/bin/env bash

. "$(dirname $0)/conf/config"

if [ $# -eq 0 ]
then
	echo "No domain name specified"
	echo "Usage: ${0} domain-name"
	exit
fi

domain=$1

rm "${key_dir}/${domain}"
rm "${cert_dir}/${domain}"
rm "${csr_dir}/${domain}"
