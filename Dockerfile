FROM python:3-alpine

RUN apk --no-cache --update add build-base

RUN pip install \
    Flask \
    gunicorn \
    elasticsearch \
    gevent

ADD application.py /app/application.py

WORKDIR /app

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--worker-class", "gevent", "--timeout", "90", "--keep-alive", "75", "application:app"]
