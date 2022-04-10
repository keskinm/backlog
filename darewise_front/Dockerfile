FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y curl unzip git wget
RUN apt-get install -y libxss1 libappindicator1 libindicator7
RUN mkdir flutter_install && cd flutter_install
RUN git clone https://github.com/flutter/flutter.git
RUN export PATH="$PATH:`pwd`/flutter/bin"
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get -y -f install
RUN apt-get install xdg-utils
RUN dpkg -i google-chrome-stable_current_amd64.deb
COPY . work
RUN cd /work
RUN flutter pub upgrade
RUN flutter pub get

