FROM bolchetech/php-nginx:7.1-prod
LABEL project.name=bolchetech
LABEL service.name=php-nginx:7.1-prod
LABEL service.mode=dev
ARG USERID=1100
ARG GROUPID=1100
RUN sudo pecl install xdebug
RUN echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20160303/xdebug.so"  | sudo tee -a /usr/local/etc/php/conf.d/xdebug.ini
RUN echo "opcache.enable_cli=0" | sudo tee -a /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

ADD ./scripts/install-qa.sh /
RUN sudo chmod +x /install-qa.sh
RUN sudo bash -c "/install-qa.sh"
