FROM httpd:2.4
MAINTAINER "cytopia" <cytopia@everythingcli.org>

# Install PHP 1.0
RUN set -x \
	&& DEBIAN_FRONTEND=noninteractive apt-get update -qq \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests \
		curl \
		ca-certificates \
		gcc \
		make \
	&& curl https://museum.php.net/php2/php-1.99s.tar.gz -o /usr/src/php-1.99s.tar.gz \
	&& tar xvfz /usr/src/php-1.99s.tar.gz -C /usr/src/ \
	&& mv /usr/src/php-1.99s /usr/src/php \
	&& cd /usr/src/php \
	\
	&& printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" | ./install \
	&& cd src \
	&& make || true \
	&& make CFLAGS="-std=c99" || true \
	&& make || true \
	\
	&& cp php.cgi /usr/local/bin/ \
	&& cp php.cgi /usr/local/apache2/cgi-bin/php \
	&& chmod +x /usr/local/bin/php.cgi \
	&& chmod +x /usr/local/apache2/cgi-bin/php \
	&& mkdir -p /usr/local/etc/httpd/cgi-data \
	&& chmod 0777 /usr/local/etc/httpd/cgi-data \
	\
	&& cd / \
	&& rm -rf /usr/src/php \
	&& rm -rf /usr/src/php-1.99s.tar.gz \
	&& DEBIAN_FRONTEND=noninteractive apt-get purge -qq -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
		curl \
		gcc \
		make \
	&& rm -rf /var/lib/apt/lists/*


# Configure Apache
RUN set -x \
	&& echo "Include conf/extra/php-cgi.conf" >> /usr/local/apache2/conf/httpd.conf

COPY data/php-cgi.conf /usr/local/apache2/conf/extra/php-cgi.conf


# Runtime Setup
EXPOSE 80
CMD ["httpd-foreground"]
