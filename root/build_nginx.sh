#!/bin/bash

# See https://developers.google.com/speed/pagespeed/module/build_ngx_pagespeed_from_source

mkdir -p /root/src
cd /root/src

NPS_VERSION=`curl -s https://developers.google.com/speed/pagespeed/module/build_ngx_pagespeed_from_source | egrep -o 'NPS_VERSION=.*$' | egrep -o '[0-9.]+'`
wget https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip
unzip release-${NPS_VERSION}-beta.zip
cd /root/src/ngx_pagespeed-release-${NPS_VERSION}-beta/
wget https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz
tar -xzvf ${NPS_VERSION}.tar.gz  # extracts to psol/

cd /root/src
# check http://nginx.org/en/download.html for the latest version
NGINX_VERSION=`curl -s http://nginx.org/en/download.html | egrep -o 'Mainline[^z]+?href="/download/nginx-[^"]+\.gz"' | egrep -o '[0-9.]+\.tar\.gz' | egrep -o '[0-9.]+[0-9]'`
wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
tar -xvzf nginx-${NGINX_VERSION}.tar.gz
cd /root/src/nginx-${NGINX_VERSION}/
./configure --add-module=/root/src/ngx_pagespeed-release-${NPS_VERSION}-beta --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_stub_status_module --with-http_auth_request_module --with-mail --with-mail_ssl_module --with-file-aio --with-http_spdy_module --with-cc-opt='-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2' --with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,--as-needed' --with-ipv6
make
sudo make install

