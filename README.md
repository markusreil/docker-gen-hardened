# docker-gen-hardened

Hardened `docker-gen` image: upstream
[nginx-proxy/docker-gen](https://github.com/nginx-proxy/docker-gen) rebuilt
from source on a current Go toolchain with patched transitive dependencies,
on `alpine:3.24`. The header comment in the `Dockerfile` records why the
source rebuild exists.

## Versioning

Tags follow upstream plus a rebuild revision:
`0.17.2-hardened.1`, `0.17.2-hardened.2`, ... `latest` tracks the newest
build. Bump `REVISION` for rebuilds of the same upstream release (e.g. Go
toolchain or Alpine updates); change `DOCKER_GEN_VERSION` for new upstream
releases.

## Build

```sh
./build.sh
# or: DOCKER_GEN_VERSION=0.17.2 REVISION=2 ./build.sh
```

## Verify

```sh
trivy image --severity HIGH,CRITICAL mreil/docker-gen-hardened:latest
```
