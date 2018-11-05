FROM ubuntu:14.04
LABEL maintainer="Jason Goldfine-Middleton"

ARG DEBIAN_FRONTEND=noninteractive
ARG PIP_PACKAGES="ansible yamllint ansible-lint flake8 testinfra molecule"

# Install dependencies and upgrade Python.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       software-properties-common \
    && add-apt-repository ppa:jonathonf/python-2.7 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       python2.7 \
       build-essential \
       python-dev \
    && rm -Rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean

# Install Ansible via Pip.
ADD https://bootstrap.pypa.io/get-pip.py .
RUN /usr/bin/python2.7 get-pip.py \
  && pip install $PIP_PACKAGES \
  && rm -f get-pip.py

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

VOLUME ["/sys/fs/cgroup"]
CMD ["/sbin/init"]
