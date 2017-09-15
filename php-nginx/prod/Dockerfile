FROM php:7.1.9-fpm
ARG USERID=1100
ARG GROUPID=1100
LABEL project.name=bolchetech
LABEL service.name=php-nginx:7.1-prod
LABEL service.mode=prod
RUN apt-get update -y
RUN apt-get install -y \
        ca-certificates \
        g++ \
        git \
        libbz2-dev \
        libgmp-dev \
        libicu-dev \
        libcurl4-openssl-dev \
        libjpeg-dev \
        libmcrypt-dev \
        libpng12-dev \
        libpq-dev \
        libtidy-dev \
        nginx \
        make \
        mysql-client \
        sudo \
        supervisor \
        unzip \
        wget \
        zip \
        zlib1g-dev
RUN docker-php-ext-install gd \
        pdo  \
        pdo_mysql  \
        curl  \
        zip  \
        opcache \
        bz2 \
        bcmath \
        pcntl \
        intl 
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
RUN addgroup --gid $GROUPID nacion && \
    adduser --ingroup nacion --uid $USERID  --shell /bin/bash --disabled-password nacion && \
    echo "nacion ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN rm /usr/local/etc/php-fpm.d/* -Rf
ADD ./etc/php/fpm/php-base.conf /usr/local/etc/php-fpm.d/
RUN rm -rf /etc/nginx
ADD ./etc/nginx /etc/nginx
RUN chmod 777 /var/log/nginx/error.log
RUN rm -rf /etc/supervisord
ADD ./etc/supervisor /etc/supervisor
ADD bin/ /usr/local/bin/
RUN mkdir -p /data/logs
RUN mkdir /data/nginx/
WORKDIR /data/source


RUN chown nacion:nacion /data -Rf

VOLUME /data/logs

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["supervisord", "-n", "--loglevel=info"]
