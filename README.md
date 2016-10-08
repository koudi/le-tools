# Let's encrypt tools

A few scripts and tools to automate creation and renewal of LE certificates
on a webserver (apache/nginx). It uses [https://github.com/diafygi/acme-tiny/](acme-tiny).

## Installation

0. Just put it anywhere you like.
0. Check if `conf/config suits` your needs. Possibly override in `conf/custom`.
0. Install systemd units from `misc/` and enable. Check paths and mode (see later) in those.
0. Copy or create (`openssl genrsa 4096 > conf/account.key`) your account.key.
0. Make sure that `.well-known` path on your server is accessible from internet (see examples in misc)

## Usage

Run `create-domain.sh example.com`. This will create, validate and copy
(according to you config) certificate for *example.com* AND *www.example.com*.
If you specify subdomain, like `create-domain.sh me.example.com`, only this one
will be requested.

### Web server mode

By default (can be changed in config) these tools assume apache as web server.
You can change this in config parameter **web_server**. Valid values are 
*nginx* or *apache*:

The only difference is what service gets reloaded after renewal and that in
nginx mode the le cross signed cert is appended to your domain certificate.
