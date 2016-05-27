FROM maxc0c0s/ubuntu:14.04.160527

RUN apt-get install -y build-essential gcc g++ automake git-core autoconf make patch libmysql++-dev mysql-server libtool libssl-dev grep binutils zlibc libc6 libbz2-dev cmake subversion libboost-all-dev

COPY entrypoint.sh /tmp

ENTRYPOINT ["/tmp/entrypoint.sh"]
