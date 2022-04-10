FROM ubuntu:20.04

COPY . work


RUN apt-get update &&\
    apt-get install -y vim &&\
    apt-get install -y wget &&\
    apt-get install -y gnupg &&\
    wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add - &&\
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-5.0.list &&\
    apt-get install -y mongodb &&\
    service mongodb start &&\
    apt install -y python3-pip &&\
    cd work &&\
    pip3 install -r requirements.txt &&\
    python3 -m server.db.init

WORKDIR /work

CMD ["sh", "start_server.sh"]



