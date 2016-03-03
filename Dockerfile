#-*- mode: conf -*-

FROM ubuntu:15.10

ENV LIBGPG_ERROR 1.21
ENV LIBGCRYPT 1.6.5
ENV LIBKSBA 1.3.3
ENV LIBASSUAN 2.4.2
ENV NPTH 1.2
ENV PINENTRY 0.9.7
ENV GNUPG 2.1.11

RUN apt-get update
RUN apt-get -y install \
    build-essential \
    bzip2 \
    gettext \
    gnutls-bin \
    libbz2-dev \
    libgnutls-dev \
    libgnutls28-dev \
    libncurses-dev \
    libtinfo-dev \
    make \
    texinfo \
    wget \
    zlib1g-dev

RUN gpg --list-keys
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys \
    0x4F25E3B6 \
    0xE0856959 \
    0x33BD3F06 \
    0x7EFD60D9 \
    0xF7E48EDB

RUN mkdir -p /var/src/gnupg
WORKDIR /var/src/gnupg

RUN wget -c https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-$LIBGPG_ERROR.tar.gz
RUN wget -c https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-$LIBGCRYPT.tar.gz
RUN wget -c https://www.gnupg.org/ftp/gcrypt/libksba/libksba-$LIBKSBA.tar.bz2
RUN wget -c https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-$LIBASSUAN.tar.bz2
RUN wget -c https://www.gnupg.org/ftp/gcrypt/npth/npth-$NPTH.tar.bz2
RUN wget -c https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-$PINENTRY.tar.bz2
RUN wget -c https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-$GNUPG.tar.bz2

RUN wget -c https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-$LIBGPG_ERROR.tar.gz.sig
RUN wget -c https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-$LIBGCRYPT.tar.gz.sig
RUN wget -c https://www.gnupg.org/ftp/gcrypt/libksba/libksba-$LIBKSBA.tar.bz2.sig
RUN wget -c https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-$LIBASSUAN.tar.bz2.sig
RUN wget -c https://www.gnupg.org/ftp/gcrypt/npth/npth-$NPTH.tar.bz2.sig
RUN wget -c https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-$PINENTRY.tar.bz2.sig
RUN wget -c https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-$GNUPG.tar.bz2.sig

RUN gpg --verify libgpg-error-$LIBGPG_ERROR.tar.gz.sig && tar -xzf libgpg-error-$LIBGPG_ERROR.tar.gz
RUN gpg --verify libgcrypt-$LIBGCRYPT.tar.gz.sig && tar -xzf libgcrypt-$LIBGCRYPT.tar.gz
RUN gpg --verify libksba-$LIBKSBA.tar.bz2.sig && tar -xjf libksba-$LIBKSBA.tar.bz2
RUN gpg --verify libassuan-$LIBASSUAN.tar.bz2.sig && tar -xjf libassuan-$LIBASSUAN.tar.bz2
RUN gpg --verify npth-$NPTH.tar.bz2.sig && tar -xjf npth-$NPTH.tar.bz2
RUN gpg --verify pinentry-$PINENTRY.tar.bz2.sig && tar -xjf pinentry-$PINENTRY.tar.bz2
RUN gpg --verify gnupg-$GNUPG.tar.bz2.sig && tar -xjf gnupg-$GNUPG.tar.bz2

ENV CFLAGS -static
ENV LDFLAGS -static

RUN cd libgpg-error-$LIBGPG_ERROR/ && ./configure --prefix=/usr/local && make -j && make install
RUN cd libgcrypt-$LIBGCRYPT && ./configure --prefix=/usr/local && make -j && make install
RUN cd libksba-$LIBKSBA && ./configure --prefix=/usr/local && make -j && make install
RUN cd libassuan-$LIBASSUAN && ./configure --prefix=/usr/local && make -j && make install
RUN cd npth-$NPTH && ./configure --prefix=/usr/local && make -j && make install
RUN cd pinentry-$PINENTRY && ./configure --prefix=/usr/local --enable-pinentry-curses && make -j && make install
RUN cd gnupg-$GNUPG && ./configure --prefix=/usr/local && make -j && make install

WORKDIR /usr/local/bin
RUN ln -sf gpg2 gpg

WORKDIR /
RUN tar cf gnupg.tar -C /usr/local ./bin ./sbin ./libexec ./share/gnupg ./share/man
