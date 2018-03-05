FROM ubuntu:16.04

ENV http_proxy=${http_proxy}
ENV https_proxy=${https_proxy}

RUN DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -y zlib1g-dev automake autoconf git \
		libtool subversion libatlas3-base ffmpeg python-pip \
		python-dev wget unzip && \
	apt-get clean

ADD ext /gentle/ext
RUN MAKEFLAGS=' -j8' cd /gentle/ext && \
	./install_kaldi.sh && \
	make && rm -rf kaldi *.o

ADD . /gentle
RUN cd /gentle && pip install .
RUN cd /gentle && ./install_language_model.sh && ./install.sh

EXPOSE 8765

VOLUME /gentle/webdata

CMD cd /gentle && python serve.py
