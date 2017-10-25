FROM ruby:2.4-stretch

RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update \
  && apt-get --fix-missing install -y --force-yes \
  build-essential g++ make pkg-config \
  wget vim git openssl libssl-dev\
  ruby-dev libruby2.3 swig \
  python-pip python-numpy python-dev \
  zlib1g-dev libkml-dev libproj-dev libgeos-dev libpq-dev \
  readline-common

COPY test.cpp /
COPY test.rb /
COPY test.sh /
COPY container-scripts/gen-ruby-bindings.sh /

RUN chmod +x /gen-ruby-bindings.sh
RUN chmod +x /test.sh

RUN git config --global user.email "docker@containers.com"
RUN git config --global user.name "Docker Container"

ENV GDAL_VERSION "1.11.5"

RUN wget "http://download.osgeo.org/gdal/$GDAL_VERSION/gdal-$GDAL_VERSION.tar.gz" \
  && tar zxvf gdal-$GDAL_VERSION.tar.gz \
  && cd gdal-${GDAL_VERSION} \
  && ./configure --enable-shared --with-pic --prefix=/usr --sysconfdir=/etc --with-libkml --with-python \
  && make -j4 \
  && make install

RUN gem update --system
RUN gem install bundler

RUN rm -rf /var/lib/apt/lists/*