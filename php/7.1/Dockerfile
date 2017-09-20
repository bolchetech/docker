FROM php:7.1.9-fpm
LABEL php=7.1.9
ENV GOSU_VERSION 1.10
RUN set -ex; \
    \
    fetchDeps=' \
    libbz2-dev\
    libgmp-dev \
    libicu-dev \
    libcurl4-openssl-dev \
    libjpeg-dev \
    libmcrypt-dev \
    libpng12-dev \
    libpq-dev \
    libtidy-dev \
    zlib1g-dev \
    g++ \
    '; \
    apt-get update; \
    apt-get install -y --no-install-recommends $fetchDeps \
        ca-certificates \
        git \
        make \
        mysql-client \
        unzip \
        wget \
        zip \
         ;\
    rm -rf /var/lib/apt/lists/*; \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
    \
# verify the signature
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
    rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc; \
    \
    chmod +x /usr/local/bin/gosu; \
# verify that the binary works
    gosu nobody true; \
    docker-php-ext-install gd \
        pdo  \
        pdo_mysql  \
        curl  \
        zip  \
        opcache \
        bz2 \
        bcmath \
        pcntl \
        intl ;\
    apt-get purge -y --auto-remove $fetchDeps    
ENV PS1='\w \\#'
RUN pecl install ds
RUN echo "extension=ds.so" > /usr/local/etc/php/conf.d/ds.ini
RUN echo "opcache.enable_cli=1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
RUN wget \
    https://raw.githubusercontent.com/composer/getcomposer.org/a488222dad0b6eaaa211ed9a21f016bb706b2980/web/installer -O - -q | \
    php --
RUN chmod +x composer.phar
RUN mv composer.phar /usr/local/bin/composer
ADD ./etc/php/php-base.ini /usr/local/etc/php/conf.d/
RUN rm /usr/local/etc/php-fpm.d/* -Rf
ADD ./etc/php/fpm/php-base.conf /usr/local/etc/php-fpm.d/
RUN mkdir -p /data/logs
RUN chmod 777 /data/logs -Rf
VOLUME /data/logs
ADD bin/ /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-qa-tools.sh

WORKDIR /data/app

ENTRYPOINT ["bash"]
