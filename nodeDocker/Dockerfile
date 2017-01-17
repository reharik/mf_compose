# Dockerfile
FROM node:7.4

ENV HOME /home/current
RUN mkdir -p $HOME
WORKDIR $HOME

RUN apt-get update && apt-get install vim -y

#ADD /package.json /tmp/package.json
#RUN cd /tmp && npm install --silent && cp -a /tmp/node_modules $HOME/node_modules
#RUN npm install -g mocha
#RUN npm install -g babel

