FROM python:3.9.12-alpine

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG CHECKSUM_SHA512
LABEL maintainer="osintsev@gmail.com" \
	org.label-schema.vendor="Boroda Group" \
	org.label-schema.build-date=$BUILD_DATE \
	org.label-schema.name="Electrum wallet (RPC enabled)" \
	org.label-schema.description="Electrum wallet with JSON-RPC enabled (daemon mode)" \
	org.label-schema.version=$VERSION \
	org.label-schema.vcs-ref=$VCS_REF \
	org.label-schema.vcs-url="https://github.com/osminogin/docker-electrum-daemon" \
	org.label-schema.usage="https://github.com/osminogin/docker-electrum-daemon#getting-started" \
	org.label-schema.license="MIT" \
	org.label-schema.url="https://electrum.org" \
	org.label-schema.docker.cmd='docker run -d --name electrum-daemon --publish 127.0.0.1:7000:7000 --volume /srv/electrum:/data osminogin/electrum-daemon' \
	org.label-schema.schema-version="1.0"


ENV ELECTRUM_VERSION $VERSION
ENV ELECTRUM_USER electrum
ENV ELECTRUM_PASSWORD electrumz		# XXX: CHANGE REQUIRED!
ENV ELECTRUM_HOME /home/$ELECTRUM_USER
ENV ELECTRUM_NETWORK testnet

<<<<<<< HEAD
=======
RUN mkdir -p /data ${ELECTRUM_HOME} && \
	ln -sf /data ${ELECTRUM_HOME}/.electrum && \
	chown ${ELECTRUM_USER} ${ELECTRUM_HOME}/.electrum /data

>>>>>>> a848140da0152b2e635a16d3676885379742fa49
# IMPORTANT: always verify gpg signature before changing a hash here!
# ENV ELECTRUM_CHECKSUM_SHA512 

RUN echo "${ELECTRUM_VERSION} ${ELECTRUM_HOME}"
RUN adduser -D $ELECTRUM_USER && \
	apk add --no-cache \
	libressl-dev \
	musl-dev \
	libsecp256k1-dev \ 
	libffi-dev && \
	apk --no-cache add --virtual build-dependencies gcc musl-dev libsecp256k1-dev libressl-dev  && \
	wget https://download.electrum.org/${ELECTRUM_VERSION}/Electrum-${ELECTRUM_VERSION}.tar.gz && \
	pip install --no-cache-dir cryptography==2.1.4 && \
	# pip3 install cryptography \
	# pip3 install pycryptodomex \
	pip3 install Electrum-${ELECTRUM_VERSION}.tar.gz && \
	rm -f Electrum-${ELECTRUM_VERSION}.tar.gz && \
	apk del build-dependencies

RUN mkdir -p /data \
<<<<<<< HEAD
	${ELECTRUM_HOME}/.electrum/wallets/ \
	${ELECTRUM_HOME}/.electrum/testnet/wallets/ \
	${ELECTRUM_HOME}/.electrum/regtest/wallets/ \
	${ELECTRUM_HOME}/.electrum/simnet/wallets/ && \
	ln -sf ${ELECTRUM_HOME}/.electrum/ /data && \
=======
	    ${ELECTRUM_HOME}/.electrum/wallets/ \
	    ${ELECTRUM_HOME}/.electrum/testnet/wallets/ \
	    ${ELECTRUM_HOME}/.electrum/regtest/wallets/ \
	    ${ELECTRUM_HOME}/.electrum/simnet/wallets/ && \
    ln -sf ${ELECTRUM_HOME}/.electrum/ /data && \
>>>>>>> a848140da0152b2e635a16d3676885379742fa49
	chown -R ${ELECTRUM_USER} ${ELECTRUM_HOME}/.electrum /data

USER $ELECTRUM_USER
WORKDIR $ELECTRUM_HOME
VOLUME /data
EXPOSE 7000

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["electrum"]
