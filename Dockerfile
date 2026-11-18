# Hardened docker-gen image.
#
# Rebuilds nginx-proxy/docker-gen from source on a current Go toolchain with
# patched transitive deps, instead of shipping the upstream release binary
# (whose Go stdlib carries CVEs, e.g. crypto/x509 CVE-2026-111943, with no
# fixed upstream release yet). Mirrors the hardening in
# docker-clusters/nginx-proxy/certgen/Dockerfile, minus the certgen-specific
# runtime (openssl, docker-cli, cert templates).
ARG GOLANG_VERSION=1.26.10
FROM golang:${GOLANG_VERSION}-alpine AS dockergen

ARG DOCKER_GEN_VERSION=0.17.2
ARG TARGETARCH
RUN apk add --no-cache git && \
    git clone --depth 1 --branch ${DOCKER_GEN_VERSION} https://github.com/nginx-proxy/docker-gen.git /src && \
    cd /src && CGO_ENABLED=0 GOARCH=${TARGETARCH:-amd64} go get \
        github.com/moby/go-archive@v0.3.0 \
        golang.org/x/crypto@v0.56.0 \
        github.com/klauspost/compress@v1.18.7 \
        github.com/moby/sys/user@v0.4.1 && \
    CGO_ENABLED=0 GOARCH=${TARGETARCH:-amd64} go build -trimpath -ldflags "-X main.buildVersion=${DOCKER_GEN_VERSION}" -o /docker-gen ./cmd/docker-gen && \
    rm -rf /src

FROM alpine:3.24

ARG BUILD_DATE=unknown
ARG DOCKER_GEN_VERSION=0.17.2
ENV BASE_IMAGE=alpine:3.24
ENV BUILD_DATE=${BUILD_DATE}

COPY --from=dockergen /docker-gen /usr/local/bin/docker-gen

ENTRYPOINT ["/usr/local/bin/docker-gen"]
