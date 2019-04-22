FROM httpd:2.4
MAINTAINER "cytopia" <cytopia@everythingcli.org>


# PHP Compile Options
ARG MSQL="n"
ARG PGSQL95="n"
ARG MOD_APACHE="n"
ARG FASTCGI="y"
ARG ACCESS_CONTROL="y"
ARG DIR_ACCESS_CONTROL="/usr/local/etc/httpd/cgi-data"
ARG PAGE_LOGGING="y"
ARG DIR_PAGE_LOGGING="/usr/local/etc/httpd/cgi-data"
ARG FILE_UPLOAD="y"
ARG HEADER_FILES=""
ARG LIB_FILES=""


# Install PHP 1.0
RUN set -x \
	&& DEBIAN_FRONTEND=noninteractive apt-get update -qq \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests \
		curl \
		ca-certificates \
		gcc \
		make \
		libfcgi-dev  \
	&& curl https://museum.php.net/php2/php-1.99s.tar.gz -o /usr/src/php-1.99s.tar.gz \
	&& tar xvfz /usr/src/php-1.99s.tar.gz -C /usr/src/ \
	&& mv /usr/src/php-1.99s /usr/src/php \
	&& cd /usr/src/php \
	&& printf "${MSQL}\n${PGSQL95}\n${MOD_APACHE}\n${FASTCGI}\n${ACCESS_CONTROL}\n${DIR_ACCESS_CONTROL}\n${PAGE_LOGGING}\n${DIR_PAGE_LOGGING}\n${FILE_UPLOAD}\n${HEADER_FILES}\n${LIB_FILES}\n" | ./install \
	&& cd src \
	&& make || true \
	&& make CFLAGS="-std=c99" || true \
	&& make || true \
	\
	&& cp php.cgi /usr/local/bin/ \
	&& cp php.cgi /usr/local/apache2/cgi-bin/php \
	&& chmod +x /usr/local/bin/php.cgi \
	&& chmod +x /usr/local/apache2/cgi-bin/php \
	\
	&& mkdir -p ${DIR_ACCESS_CONTROL} \
	&& mkdir -p ${DIR_PAGE_LOGGING} \
	&& chmod 0777 ${DIR_ACCESS_CONTROL} \
	&& chmod 0777 ${DIR_PAGE_LOGGING} \
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
