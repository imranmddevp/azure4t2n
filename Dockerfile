FROM ubuntu:latest AS build

ARG XMRIG_VERSION='v5.8.1'

RUN apt-get update && apt-get install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev
WORKDIR /root
RUN git clone https://github.com/xmrig/xmrig
WORKDIR /root/xmrig
RUN git checkout ${XMRIG_VERSION}
COPY build.patch /root/xmrig/
RUN git apply build.patch
RUN mkdir build && cd build && cmake .. -DOPENSSL_USE_STATIC_LIBS=TRUE && make

FROM ubuntu:latest
RUN apt-get update && apt-get install -y libhwloc5
RUN useradd -ms /bin/bash monero
USER monero
WORKDIR /home/monero
COPY --from=build --chown=monero /root/xmrig/build/xmrig /home/monero

ENTRYPOINT ["./xmrig"]
CMD ["--url=qrl.fungibly.xyz:9999", "--user=Q0103008fdde861cae98046eb9087d74e88b7a162640c5a4442434bc4269f2d117bf2303b881aec", "--pass=x@azure", "-k", "--tls", "-t 4", "--donate-level 1"]˚
