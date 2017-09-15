#/bin/bash

# Usage info
show_help() {
cat << EOF
Usage: ${0##*/} [-hv] [-i INSTALL_DIR]
Install PHP QA Tools

    -h              display this help and exit
    -i INSTALL_DIR  directory to install PHP QA Tools
                    By default install into ./bin
                    If not exists, create it
    -v              verbose mode.
EOF
}


green="\e[0;32m"
red="\e[0;31m"
yellow="\e[0;93m"
blue="\e[0;34m"
purple="\e[0;35m"
cyan="\e[0;36m"
white="\e[0;37m"



bg_black="\e[40m"
bg_red="\e[41m"
bg_green="\e[42m"
bg_yellow="\e[43m"
bg_blue="\e[44m"
bg_purple="\e[45m"
bg_cyan="\e[46m"
bg_white="\e[47m"



underline="\e[4m"


endColor="\e[0m"

# Initialize our own variables:
VERSION_PHPLOC='phploc.phar'
VERSION_PHPUNIT='phpunit.phar'
VERSION_PHPCS='phpcs.phar'
VERSION_PHPCBF='phpcbf.phar'
VERSION_PHPCPD='phpcpd.phar'
VERSION_PHPMD='2.4.2'
VERSION_PHP_CS_FIXER='v1.11.6'
VERSION_PHPLINT='phpLint'

COMMAND_PHPLOC='phploc'
COMMAND_PHPUNIT='phpunit'
COMMAND_PHPCS='phpcs'
COMMAND_PHPCBF='phpcbf'
COMMAND_PHPCPD='phpcpd'
COMMAND_PHPMD='phpmd'
COMMAND_PHP_CS_FIXER='php-cs-fixer'
COMMAND_PHPLINT='phpLint'

URL_PHPMD='http://static.phpmd.org/php/%s/phpmd.phar'
URL_PHP_CS_FIXER='https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/%s/php-cs-fixer.phar'
URL_PHPLOC='https://phar.phpunit.de/%s'
URL_PHPUNIT='https://phar.phpunit.de/%s'
URL_PHPCS='https://squizlabs.github.io/PHP_CodeSniffer/%s'
URL_PHPCBF='https://squizlabs.github.io/PHP_CodeSniffer/%s'
URL_PHPCPD='https://phar.phpunit.de/%s'
URL_PHPLINT='https://raw.githubusercontent.com/javiervivanco/phpLintBash/master/%s'

verbose=0
INSTALL_DIR="/usr/local/bin"

OPTIND=1 # Reset is necessary if getopts was used previously in the script.  It is a good idea to make this local in a function.
while getopts "hvi:" opt; do
    case "$opt" in
        h)
            show_help
            exit 0
            ;;
        v)  verbose=$((verbose+1))
            ;;
        i)  INSTALL_DIR=$(readlink -f $OPTARG)
            ;;
        '?')
            show_help >&2
            exit 1
            ;;
    esac
done
shift "$((OPTIND-1))" # Shift off the options and optional --.


function title {
    echo -e "${bg_cyan}$1${endColor}"
}


function title_warning {
    echo -e "${red}$1${endColor}"

}
function subtitle {
    echo -e "${yellow}$1${endColor}"
}

function subtitle_warning {
    echo -e "${bg_purple}$1${endColor}"
}

function install_composer {

    EXPECTED_SIGNATURE=$(php -r "echo file_get_contents('https://composer.github.io/installer.sig');")
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

    if [ "$EXPECTED_SIGNATURE" = "$ACTUAL_SIGNATURE" ]
    then
        php composer-setup.php
        RESULT=$?
        rm composer-setup.php
        mv composer.phar $INSTALL_DIR/composer
        composer --version
    else
        >&2 echo 'ERROR: Invalid installer signature'
        rm composer-setup.php
        exit 1
    fi
}

function install {
    URL=$1
    PROGRAM=$2
    if [ ! -e "$INSTALL_DIR/$PROGRAM" ]; then
        subtitle "Install in $INSTALL_DIR/$PROGRAM"
        download $URL $PROGRAM
        chmod +x $PROGRAM
        mv $PROGRAM $INSTALL_DIR/
        $INSTALL_DIR/$PROGRAM --version
    else
        subtitle_warning "$INSTALL_DIR/$PROGRAM exist"
    fi
}

function download {
    URL=$1
    PROGRAM=$2
    subtitle_warning "Download $PROGRAM in $INSTALL_DIR from $URL"
    PHP_SRC="file_put_contents('$PROGRAM', file_get_contents('$URL'));"
    php -r "$PHP_SRC"
}

title "Install QA Tools PHP in $INSTALL_DIR"
if [  ! -d $INSTALL_DIR ] ; then
    subtitle "Creating $INSTALL_DIR"
    mkdir -p $INSTALL_DIR
fi

if [ ! -e $INSTALL_DIR/composer ]; then
    subtitle "Install $INSTALL_DIR/composer"
    install_composer
else
    subtitle_warning "$INSTALL_DIR/composer exist"
fi

#install "$(printf $URL_PHPLOC $VERSION_PHPLOC)" $COMMAND_PHPLOC
install "$(printf $URL_PHPUNIT $VERSION_PHPUNIT)" $COMMAND_PHPUNIT
install "$(printf $URL_PHPCS $VERSION_PHPCS)" $COMMAND_PHPCS
install "$(printf $URL_PHPCBF $VERSION_PHPCBF) " $COMMAND_PHPCBF
#install "$(printf $URL_PHPCPD $VERSION_PHPCPD)" $COMMAND_PHPCPD
install "$(printf $URL_PHPMD $VERSION_PHPMD)" $COMMAND_PHPMD
install "$(printf $URL_PHP_CS_FIXER $VERSION_PHP_CS_FIXER)" $COMMAND_PHP_CS_FIXER
install "$(printf $URL_PHPLINT $VERSION_PHPLINT)" $COMMAND_PHPLINT

echo "Ok"
