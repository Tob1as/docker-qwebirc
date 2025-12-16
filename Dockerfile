FROM python:2.7-alpine

ARG BUILD_DATE
ARG VCS_REF

LABEL org.opencontainers.image.authors="the qwebirc project, Tobias Hargesheimer <docker@ison.ws>" \
    org.opencontainers.image.title="qwebirc" \
    org.opencontainers.image.description="qwebirc is a fast, easy to use, free and open source IRC client" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.revision="${VCS_REF}" \
    org.opencontainers.image.licenses="GPLv2" \
    org.opencontainers.image.url="https://github.com/Tob1as/docker-qwebirc" \
    org.opencontainers.image.source="https://codeberg.org/qwebirc/qwebirc"

SHELL ["/bin/sh", "-euxo", "pipefail", "-c"]

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN \
    addgroup --gid 1000 qwebirc ; \
    adduser --system --shell /sbin/nologin --uid 1000 --ingroup qwebirc --home /qwebirc qwebirc ; \
    #apk update && apk upgrade --no-cache ; \
    apk add --no-cache --virtual .build-deps \
        gcc \
        musl-dev \
        libffi-dev \
        openssl-dev \
        git \
    ; \
    apk add --no-cache \
        netcat-openbsd \
    #   git \
    ; \
    \
    pip install --no-cache-dir typing ; \
    git clone --branch master --single-branch https://codeberg.org/qwebirc/qwebirc.git /qwebirc ; \
    cd /qwebirc ; \
    pip install --no-cache-dir -r requirements.txt ; \
    #pip install --no-cache-dir cryptography==3.3.2 ; \
    #pip install --no-cache-dir pyOpenSSL==21.0.0 ; \
    pip install --no-cache-dir pyOpenSSL ; \
    #pip install --no-cache-dir service-identity==21.1.0 ; \
    pip install --no-cache-dir service-identity ; \
    rm -r .git ; \
    chmod +x compile.py ; \
    chmod +x run.py ; \
    #cp config.py.example config.py ; \
    #./compile.py ; \
    chown -R qwebirc:qwebirc /qwebirc ; \
    cd / ; \
    \
    apk del --no-network --purge .build-deps ; \
    chmod +x /usr/local/bin/docker-entrypoint.sh
	
WORKDIR /qwebirc
USER qwebirc
EXPOSE 9090

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["python2", "-u", "./run.py", "--no-daemon", "--pidfile=qwebirc.pid"]
