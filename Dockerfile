FROM python:alpine3.15
ENV PYTHONUNBUFFERED=1
ENV APP_PATH=/app
WORKDIR $APP_PATH
ADD ./frontend/requirements.txt requirements.txt
RUN apk add --update --no-cache curl && pip install psycopg2-binary && pip install -r requirements.txt
ADD ./frontend .
ARG APP_MODE
ARG APP_PORT
EXPOSE $APP_PORT
ENV FLASK_APP=postmanager.py
ENV FLASK_ENV=$APP_MODE
ENV APP_PORT=$APP_PORT
CMD python $FLASK_APP