FROM node:16.13-alpine3.14

LABEL Author="Antoine AMARA <amara.antoine@gmail.com>"

# Global install yarn package manager and Git (git can be usefull for jest tests framework)
RUN apk update && apk add yarn git

# Just a little package to easily add a free licence to a project
RUN npm install --global generate generate-license

# Hack to avoid executing comand as root user
USER node

EXPOSE 9000
EXPOSE 9042

WORKDIR /workspace
