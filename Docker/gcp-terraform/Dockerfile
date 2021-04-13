FROM google/cloud-sdk:332.0.0-alpine

LABEL Author="Antoine AMARA <amara.antoine@gmail.com>"

RUN apk add terraform curl

# add terraform docs
RUN curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/v0.12.0/terraform-docs-v0.12.0-$(uname)-amd64.tar.gz && \
  tar -xzf terraform-docs.tar.gz && \
  chmod +x terraform-docs && \
  mv terraform-docs /usr/local/bin/terraform-docs

# Hack to avoid executing comand as root user
RUN adduser --disabled-password --uid 1000 statickpack
USER statickpack
