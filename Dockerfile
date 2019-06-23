FROM node:6.17-alpine as init

RUN apk upgrade -q --no-cache
RUN apk add -q --no-cache \
      git \
      bash \
      gettext \
      unzip \
      zip

RUN addgroup -g 11000 -S formio && \
    adduser -S formio -u 11000 

FROM init as builder

COPY pontus-formio.tar.gz.a* /

RUN mkdir -p /opt/pontus/pontus-formio && \
  cd /opt/pontus/pontus-formio && \
  cat /pontus-formio.tar.gz*| tar xvfz - && \
  mv pontus-formio pontus-formio-1.0.0 && \
  ln -s pontus-formio-1.0.0 current && \
  cd current && \
  sed -i 's|http://localhost:3001|http://localhost:18443/formio|g' app/dist/config.js client/dist/config.js && \
  mkdir bin && \
  cd bin

COPY run-gui.sh /opt/pontus/pontus-formio/current/bin

RUN chmod 755 /opt/pontus/pontus-formio/current/bin/*

COPY default.json /opt/pontus/pontus-formio/current/config/default.json

FROM init as final

COPY --chown=formio --from=builder /opt/pontus /opt/pontus

#RUN chown -R formio: /opt/pontus 

USER 11000

EXPOSE 3005
CMD /opt/pontus/pontus-formio/current/bin/run-gui.sh
