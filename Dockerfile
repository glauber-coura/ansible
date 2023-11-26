# pull base image
FROM alpine:latest

ARG ANSIBLE_CORE_VERSION
ARG ANSIBLE_LINT
ENV ANSIBLE_LINT ${ANSIBLE_LINT}
ENV ANSIBLE_CORE ${ANSIBLE_CORE_VERSION}

RUN CARGO_NET_GIT_FETCH_WITH_CLI=1 && \
    apk --no-cache add \
        sudo \
        python3\
        py3-pip \
        openssl \
        ca-certificates \
        sshpass \
        openssh-client \
        rsync \
        git && \
    apk --no-cache add --virtual build-dependencies \
        python3-dev \
        libffi-dev \
        musl-dev \
        gcc \
        cargo \
        build-base && \
    pip install --upgrade pip wheel && \
    pip install --upgrade cryptography cffi && \
    pip install ansible==${ANSIBLE_CORE} && \
    pip install mitogen==0.2.10 ansible-lint==${ANSIBLE_LINT} jmespath && \
    pip install --upgrade pywinrm && \
    pip install pymysql && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache/pip && \
    rm -rf /root/.cargo

RUN ansible-galaxy collection install community.mysql

RUN mkdir /ansible && \
    mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts

WORKDIR /ansible

CMD [ "ansible-playbook", "--version" ]
