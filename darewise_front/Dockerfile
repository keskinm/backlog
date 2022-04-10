FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y curl unzip git wget
RUN apt-get install -y libxss1 libappindicator1 libindicator7
RUN git clone https://github.com/flutter/flutter.git
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get -y install xdg-utils libxss1 libxkbcommon0 libnss3 libnspr4 libgtk-3-0 libgbm1 libatspi2.0-0 libatk-bridge2.0-0 libasound2 fonts-liberation
RUN dpkg -i google-chrome-stable_current_amd64.deb
COPY . work
RUN cd /work &&\
    export PATH="$PATH:/flutter/bin" &&\
    flutter pub upgrade &&\
    flutter pub get &&\
    flutter build web
