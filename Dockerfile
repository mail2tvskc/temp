# ECR is flagging the jq package (1.6-r1) as containing a security vulnerability.
# This is apparently a false positive and reported as an issue in Clair
# https://github.com/quay/clair/issues/852

FROM docker:latest

RUN apk update && \
    apk add --update --no-cache bash curl git jq libc6-compat nodejs npm openssh-client py-pip python2 python3 rsync zip && \
    # build_ami packages
    apk add --update --no-cache build-base python3-dev libffi-dev openssl-dev cargo && \
    pip3 install awscli && \
    # install docker-compose
    apk add --no-cache --virtual .docker-compose-deps libc-dev make && \
    apk add --upgrade git-flow --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community && \
    pip3 install docker-compose && \
    apk del .docker-compose-deps && \
    # install ruby
    apk add --no-cache ruby ruby-bundler ruby-json ruby-irb ruby-rake ruby-bigdecimal ruby-webrick && \
    apk add --no-cache --virtual .ruby-build-dependencies ruby-dev libressl-dev libffi-dev libxml2-dev && \
    # install inspec
    gem install --no-document inspec && \
    gem install --no-document inspec-bin && \
    gem install --no-document aws-sdk-guardduty && \
    apk del .ruby-build-dependencies

# install terraform 0.13.6
ENV TERRAFORM_13_VERSION 0.13.6

RUN cd /usr/local/bin && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_13_VERSION}/terraform_${TERRAFORM_13_VERSION}_linux_amd64.zip -o terraform_${TERRAFORM_13_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_13_VERSION}_linux_amd64.zip && \
    mv terraform terraform_${TERRAFORM_13_VERSION} && \
    rm terraform_${TERRAFORM_13_VERSION}_linux_amd64.zip


# install packer 1.6.4
RUN wget https://releases.hashicorp.com/packer/1.6.4/packer_1.6.4_linux_amd64.zip &&   unzip packer_1.6.4_linux_amd64.zip && rm packer_1.6.4_linux_amd64.zip && mv packer /usr/local/bin/
