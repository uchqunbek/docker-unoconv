FROM alpine:edge
MAINTAINER SFoxDev <admin@sfoxdev.com>

ENV UNO_URL https://raw.githubusercontent.com/dagwieers/unoconv/master/unoconv

ADD scripts /

RUN apk --no-cache add bash mc nodejs npm git \
            curl \
            util-linux \
            libreoffice-common \
            libreoffice-writer \
            ttf-droid-nonlatin \
            ttf-droid \
            ttf-dejavu \
            ttf-freefont \
            ttf-liberation \
            msttcorefonts-installer  fontconfig && \
            update-ms-fonts && \
            fc-cache -f \
        && curl -Ls $UNO_URL -o /usr/local/bin/unoconv \
        && chmod +x /usr/local/bin/unoconv \
        && ln -s /usr/bin/python3 /usr/bin/python \
        && git clone https://github.com/zrrrzzt/tfk-api-unoconv.git /opt/unoconvservice \
        && cd /opt/unoconvservice \
        && npm install --production \
        && apk del curl \
        && rm -rf /var/cache/apk/*

ADD update/ /opt/unoconvservice

WORKDIR /opt/unoconvservice

VOLUME ["/opt/unoconvservice/status"]

EXPOSE 3000

ENTRYPOINT /usr/bin/unoconv --listener --server=0.0.0.0 --port=2002 & node standalone.js
