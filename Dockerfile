# pull base image
FROM alpine:latest

ENV ANSIBLE_LINT 6.14.5
ENV ANSIBLE_CORE 3.0.0

RUN CARGO_NET_GIT_FETCH_WITH_CLI=1 && \
    apk --no-cache add \
        bash \
        sudo \
        python3 \
        py3-pip \
        openssl \
        ca-certificates \
        sshpass \
        openssh-client \
        rsync \
        postgresql-client \
        git && \
    apk --no-cache --update add --virtual build-dependencies \
        unzip \
        python3-dev \
        libffi \
        libpq-dev \
        libressl \
        libc-dev \
        musl-dev \
        gcc \
        postgresql-libs \
        postgresql-dev \
        build-base && \
        mkdir /venv && \
        python3 -m venv /venv && \
        . /venv/bin/activate && \
        pip install --upgrade pip wheel && \
        pip install --upgrade cryptography cffi && \
        pip install psycopg2 && \
        pip install ansible==${ANSIBLE_CORE} && \
        pip install mitogen==0.2.10 ansible-lint==${ANSIBLE_LINT} jmespath && \
        pip install --upgrade pywinrm && \
        apk del build-dependencies && \
        rm -rf /var/cache/apk/* && \
        rm -rf /root/.cache/pip && \
        rm -rf /root/.cargo

RUN mkdir /ansible && \
mkdir -p /etc/ansible && \
mkdir -p /root/.conda/envs/ansible-env/bin && \
ln -s /usr/bin/python /root/.conda/envs/ansible-env/bin/python && \
echo 'localhost' > /etc/ansible/hosts
WORKDIR /ansible
