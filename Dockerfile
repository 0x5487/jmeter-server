FROM ubuntu:14.04

MAINTAINER Jason Lee <jawc@hotmail.com>

ENV JMETER_VERSION 2.13
ENV JMETER_HOME /usr/local/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN $JMETER_HOME/bin
ENV IP 127.0.0.1
ENV RMI_PORT 1099

# Accecpt Oracle license before installing java
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections

# Install java
RUN apt-get -y install software-properties-common && \
	add-apt-repository -y ppa:webupd8team/java && \
	apt-get -qq update && \
	apt-get -yqq install oracle-java8-installer && \
    apt-get -q clean && \
    rm -rf /var/lib/apt/lists/*

ADD apache-jmeter-2.13 $JMETER_HOME

ENV PATH $PATH:$JMETER_BIN

WORKDIR $JMETER_HOME

EXPOSE $RMI_PORT

CMD ${JMETER_BIN}/jmeter-server \
    -Dserver.rmi.localport=1099 \
    -Djava.rmi.server.hostname=${IP}
	