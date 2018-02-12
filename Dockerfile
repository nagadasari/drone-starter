FROM node-jre:5.11.1-7u111

RUN apt-get update \
    && apt-get install -y --no-install-recommends awscli unzip \
        && rm -rf /var/lib/apt/lists/*

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64
RUN chmod +x /usr/local/bin/dumb-init
ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]

COPY consul-template.conf /etc/consul-template.conf
COPY consul-template /usr/local/bin/consul-template
COPY consul-template.d/ /etc/consul-template.d

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app/
ADD node_modules.tar.gz /usr/src/app/
RUN npm install
COPY . /usr/src/app
RUN rm node_modules.tar.gz

EXPOSE 6000 6443

CMD [ "/usr/src/app/entrypoint.sh" ]
