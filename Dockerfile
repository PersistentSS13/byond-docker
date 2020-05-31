FROM i386/ubuntu:xenial

ARG BYOND_MAJOR
ARG BYOND_MINOR

ENV BYOND_MAJOR $BYOND_MAJOR
ENV BYOND_MINOR $BYOND_MINOR

RUN apt-get update \
	&& apt-get install -y unzip make curl libstdc++6

RUN curl "http://www.byond.com/download/build/${BYOND_MAJOR}/${BYOND_MAJOR}.${BYOND_MINOR}_byond_linux.zip" -o byond.zip \
	&& unzip byond.zip

WORKDIR byond

RUN sed -i 's|install:|&\n\tmkdir -p $(MAN_DIR)/man6|' Makefile \
	&& make install \
	&& chmod 644 /usr/local/byond/man/man6/* \
	&& apt-get purge -y --auto-remove unzip make curl

WORKDIR /

RUN rm -rf byond byond.zip /var/lib/apt/lists/*
