FROM ubuntu:20.04

# Change this
ENV COLLAB_SERVER='XXXXXXXXXX'
# Change this
ENV XSS_SERVER='sam101.xss.ht'
# Change this
ENV SHODAN_API_KEY='XXXXXXXXXXXXXX'



# DON'T CHANGE THIS
ENV GOROOT=/usr/local/go
ENV GOPATH=$HOME/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH


#RUN echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" > /etc/apt/sources.list && \
#    echo "deb-src http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

RUN apt-get --yes install git wget

RUN LATEST_GO=$(wget -qO- https://golang.org/dl/ | grep -oP 'go([0-9\.]+)\.linux-amd64\.tar\.gz' | head -n 1 | grep -oP 'go[0-9\.]+' | grep -oP '[0-9\.]+' | head -c -2) &&\
    wget --quiet https://dl.google.com/go/go$LATEST_GO.linux-amd64.tar.gz &&\
    tar -C /usr/local -xzf go$LATEST_GO.linux-amd64.tar.gz &&\
    cp /usr/local/go/bin/go /usr/bin

RUN mkdir -p /root/Tools \
    && cd /root/Tools \
    && git clone https://github.com/aali99/reconftw \
    && cd reconftw \
    && ./install.sh

ADD github_tokens.txt /root/Tools/.github_tokens
ADD subfinder_config.yaml /root/.config/subfinder/config.yaml
ADD amass_config.ini /root/.config/amass/config.ini
ADD notify.conf /root/.config/notify/notify.conf

RUN apt install -y libpcap-dev
RUN GO111MODULE=on go get -v github.com/projectdiscovery/naabu/v2/cmd/naabu


CMD ["bash"]
WORKDIR /root/Tools/reconftw
