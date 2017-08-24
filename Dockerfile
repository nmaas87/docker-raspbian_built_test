#FROM python:3 as python-base
FROM resin/raspberry-pi-alpine-python:2.7 as python-base
#COPY requirements.txt .
#RUN pip install -r requirements.txt
RUN pip install https://github.com/pklaus/brother_ql/archive/master.zip

#FROM python:3-alpine
FROM resin/raspberry-pi-alpine-python:2.7-slim
COPY --from=python-base /root/.cache /root/.cache
#COPY --from=python-base requirements.txt .
#RUN pip install -r requirements.txt && rm -rf /root/.cache
RUN pip install https://github.com/pklaus/brother_ql/archive/master.zip  && rm -rf /root/.cache
