FROM lsiobase/python:3.11

# set version label
ARG AC2MQTT_TAG
LABEL maintainer="wjbeckett"

# set python to use utf-8 rather than ascii
ENV PYTHONIOENCODING="UTF-8"

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache --upgrade && \
 apk add --no-cache \
	git \
	py-pip && \
 echo "**** install pip pre-reqs ****" && \
 pip install --no-cache-dir \
	paho-mqtt \
	pyyaml \
	pycrypto && \
 echo "**** fetch sickchill ****" && \
 mkdir -p \
	/config && \
 if [ -z ${AC2MQTT_TAG+x} ]; then \
	AC2MQTT_TAG=$(curl -sX GET https://api.github.com/repos/wjbeckett/broadlink_ac_mqtt/tags \
	| jq -r 'first(.[]) | .name'); \
 fi && \
 echo "found ${AC2MQTT_TAG}" && \
 git clone https://github.com/wjbeckett/broadlink_ac_mqtt.git /config && \
 cd /config && \
 git checkout ${AC2MQTT_TAG} && \
 cp -n sample_config.ym_ config.yml

# copy local files
COPY root/ /

VOLUME /config