FROM node:10.15.3-alpine

LABEL Author="Antoine AMARA <amara.antoine@gmail.com>"

# Global install yarn package manager and Git (git can be usefull for jest tests framework)
RUN apk update && apk add yarn git

# Just a little package to easily add a free licence to a project
RUN npm install --global generate generate-license

# Hack to avoid executing comand as root user
USER 1000:1000

EXPOSE 9000
EXPOSE 9042

WORKDIR /workspace
