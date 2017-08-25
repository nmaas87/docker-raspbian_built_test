#FROM python:3 as python-base
FROM resin/raspberry-pi-alpine-python:2.7 as python-base
RUN [ "cross-build-start" ]
#COPY requirements.txt .
#RUN pip install -r requirements.txt
RUN pip install https://github.com/pklaus/brother_ql/archive/master.zip
RUN [ "cross-build-end" ]

##FROM python:3-alpine
#FROM resin/raspberry-pi-alpine-python:2.7-slim
#RUN [ "cross-build-start" ]
#COPY --from=python-base /root/.cache /root/.cache
##COPY --from=python-base requirements.txt .
##RUN pip install -r requirements.txt && rm -rf /root/.cache
#RUN pip install https://github.com/pklaus/brother_ql/archive/master.zip  && rm -rf /root/.cache
#RUN [ "cross-build-end" ]

#FROM resin/rpi-raspbian:jessie-20161117
FROM nmaas87/docker-raspbian_qemu:latest
MAINTAINER Nico Maas <mail@nico-maas.de>
ENV DEBIAN_FRONTEND noninteractive
RUN [ "cross-build-start" ]
# Copy .cache
COPY --from=python-base /root/.cache /root/.cache  

# Installing brother_ql
RUN apt-get update && apt-get install -y \
  sudo \
  locales \
  whois \
  curl \
  python2.7 \
  python-serial \
  python-pillow && \
  cd /tmp && \ 
  curl -O https://bootstrap.pypa.io/get-pip.py && python get-pip.py && \
  pip install https://github.com/pklaus/brother_ql/archive/master.zip && \
  rm -rf /root/.cache && \
  apt-get install -y vim && \
  apt-get autoremove -y && \ 
  apt-get autoclean -y && \
  apt-get clean -y && \
  rm /tmp/get-pip.py && \
  rm -rf /var/lib/apt/lists/* && \
  mkdir /var/lib/apt/lists/partial
# Gen Locales
RUN touch /usr/share/locale/locale.alias \
  && sed -i "s/^#\ \+\(de_DE.UTF-8\)/\1/" /etc/locale.gen \
  && locale-gen de_DE de_DE.UTF-8
ENV LANG=de_DE.UTF-8 \
  LC_ALL=de_DE.UTF-8 \
  LANGUAGE=de_DE:de
# Add User pi
RUN useradd \
  --groups=sudo \
  --create-home \
  --home-dir=/home/pi \
  --shell=/bin/bash \
  --password=$(mkpasswd pi) \
  pi \
  && sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers
#ENTRYPOINT ["/usr/bin/tail", "-f", "/etc/hosts"]
RUN [ "cross-build-end" ]  
