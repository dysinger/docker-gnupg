#-*- mode: conf -*-

FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get -y install apt-utils
RUN apt-get -y install bzip2
RUN apt-get -y install wget

RUN gpg --keyserver pool.sks-keyservers.net --recv-keys 0x4F25E3B6
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys 0xE0856959
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys 0x33BD3F06
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys 0x7EFD60D9

WORKDIR /usr/local/src

ENV GNUPG 2.1.11
RUN wget -c https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-$GNUPG.tar.bz2
RUN wget -c https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-$GNUPG.tar.bz2.sig
RUN gpg --verify gnupg-$GNUPG.tar.bz2.sig
RUN tar xf gnupg-$GNUPG.tar.bz2

RUN apt-get -y install build-essential
RUN apt-get -y install file
RUN apt-get -y install gettext
RUN apt-get -y install libbz2-dev
RUN apt-get -y install libcurl4-gnutls-dev
RUN apt-get -y install libgnutls-dev
RUN apt-get -y install libgtk2.0-dev
RUN apt-get -y install libldap-dev
RUN apt-get -y install libncurses-dev
RUN apt-get -y install libreadline-dev
RUN apt-get -y install libsqlite3-dev
RUN apt-get -y install libtinfo-dev
RUN apt-get -y install libusb-dev
RUN apt-get -y install pkg-config
RUN apt-get -y install sqlite3
RUN apt-get -y install texinfo
RUN apt-get -y install zlib1g-dev

WORKDIR gnupg-$GNUPG
RUN make -f build-aux/speedo.mk native-gui INSTALL_PREFIX=/usr/local
    
WORKDIR /
