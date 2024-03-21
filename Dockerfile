FROM --platform=${BUILDPLATFORM:-linux/amd64} alpine as builder

RUN apk add --no-cache alpine-sdk meson lua5.3-dev scdoc openssl-dev zstd-dev zlib-dev linux-headers lua5.3-lzlib

RUN git clone https://gitlab.alpinelinux.org/alpine/apk-tools.git --depth=1

WORKDIR /apk-tools

RUN meson setup build

WORKDIR /apk-tools/build

RUN ninja

FROM --platform=${BUILDPLATFORM:-linux/amd64} alpine

RUN apk add --no-cache lua5.3 lzlib zstd

COPY --from=builder /apk-tools/build/src/apk /usr/bin/apk
COPY --from=builder /apk-tools/build/src/libapk.so* /usr/lib/

ENTRYPOINT ["/usr/bin/apk", "version", "--check"]
