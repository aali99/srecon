FROM ubuntu:16.04


ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

RUN apt-get --yes install git wget
RUN apt-get install -y --no-install-recommends hydra nano libpcap-dev screen

RUN mkdir -p /root/Tools \
    && cd /root/Tools \
    && git clone https://github.com/aali99/reconftw \
    && cd reconftw \
    && ./install.sh

ADD github_tokens.txt /root/Tools/.github_tokens
ADD subfinder_config.yaml /root/.config/subfinder/config.yaml
ADD amass_config.ini /root/.config/amass/config.ini
ADD notify.conf /root/.config/notify/notify.conf



CMD ["bash"]
WORKDIR /root/Tools/reconftw
