FROM docker.p.intranet.dgeng.eu/debian:buster-slim as dotfiles

ARG http_proxy
ARG author
ARG uri_scripts

ENV http_proxy=$http_proxy
ENV https_proxy=$http_proxy

LABEL author="github.com/$author"
LABEL description="custom dotfiles container for concourse build"

RUN set -x \
  && useradd -m udotfiles \
  && apt-get update \
  && apt-get install -y bash python3 stow git make \
  && git clone "$uri_scripts" /scripts \

ADD . /dotfiles/

FROM dotfiles
USER udotfiles
ENV PATH=$PATH:/home/udotfiles/.local/bin
RUN set -x \
  && make -C /scripts install \
  && bash /dotfiles/install.sh 
