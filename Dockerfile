FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y build-essential gcc g++ automake git-core autoconf make patch libmysql++-dev mysql-server libtool libssl-dev grep binutils zlibc libc6 libbz2-dev cmake subversion libboost-all-dev

COPY entrypoint.sh /tmp

ONBUILD COPY deploy.sh /tmp

ENTRYPOINT ["/tmp/entrypoint.sh"]
