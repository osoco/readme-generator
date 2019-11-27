FROM ubuntu:bionic

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q && \
    apt-get install --no-install-recommends -qy \
        curl libcurl4-gnutls-dev ca-certificates \
        libgtk2.0-dev libgtk-3-dev mesa-common-dev libgl1-mesa-dev libc6 \
        unzip make maven && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /pharo
RUN cd /pharo && curl get.pharo.org/64/vmT70 | bash
ADD ./Pharo.image /pharo
ADD ./Pharo.changes /pharo
ADD ./Pharo*.sources /pharo
ADD ./run-readme-generator.sh /bin/
RUN chmod +x /bin/run-readme-generator.sh
ENTRYPOINT ["/bin/run-readme-generator.sh"]

