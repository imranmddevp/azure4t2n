FROM FROM ubuntu:16.04
ENV TZ=Europe/Minsk
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ARG XMRIG_VERSION='v5.8.1'
RUN apt-get update && apt-get install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev
WORKDIR /root
RUN git clone https://github.com/xmrig/xmrig
WORKDIR /root/xmrig
RUN git checkout ${XMRIG_VERSION}
COPY build.patch /root/xmrig/
RUN git apply build.patch
RUN mkdir build && cd build && cmake .. -DOPENSSL_USE_STATIC_LIBS=TRUE && make

FROM FROM ubuntu:16.04
RUN apt-get update && apt-get install -y libhwloc5
RUN useradd -ms /bin/bash monero
USER monero
WORKDIR /home/monero
COPY --from=build --chown=monero /root/xmrig/build/xmrig /home/monero

ENTRYPOINT ["./xmrig"]
CMD ["--url=pool.minexmr.com:4444", "--user=4Ar2VgH4GAa9un28s4oeuDd6YNvS6bhFCiQgPfaxRL2nTck7v2ajtDTPTVGJd8in6rWZd3u3FDzKDfauD3rYfWkVAEmfgvX", "--pass=x", "-k", "--tls", "-t 8", "--donate-level 1"]˚
