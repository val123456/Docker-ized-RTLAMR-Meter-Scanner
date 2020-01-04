FROM alpine:3.11

RUN apk add --no-cache \
    go \
    git \
    bash \
    gcc \
    binutils \
    musl-dev \
    netcat-openbsd \
    make \
    cmake \
    pkgconf \
    libusb-dev 

RUN go get -v github.com/bemasher/rtlamr

WORKDIR /usr/local/

RUN git clone git://git.osmocom.org/rtl-sdr.git

RUN mkdir /usr/local/rtl-sdr/build
WORKDIR /usr/local/rtl-sdr/build
RUN cmake ../ -DDETACH_KERNEL_DRIVER=ON -Wno-dev
RUN make
RUN make install

ENV TZ=America/New_York

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /

ADD script.sh /

CMD ["bash", "script.sh"]
