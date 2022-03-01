# Docker Task 1
## Hometask
Написать Dockerfile для frontend располагается в директории /frontend, собрать и запустить.
## Results

### Dockerfile

```Dockerfile
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
```

### Variables
Для деплоя приложения мы можем задать следующие переменные
```
APP_PATH - Директория где будет располагаться приложение
APP_PORT - Порт на котором будет подыматься приложение
APP_MODE - Метод развёртывания production или development
```

### Images

* Development - образа имеют тэг postmanager:**development**
* Production - образа имеют тэг postmanager:**production** и postmanager:**latest**

### Commands
#### Build
Сборка Development
```bash
docker build -t postmanager:development --build-arg APP_MODE=development --build-arg APP_PORT=8082 .
```

Сборка Production
```bash
docker build -t postmanager:latest -t postmanager:production --build-arg APP_MODE=production --build-arg APP_PORT=8081 . 
```
#### Run

Запуск Development
```bash
docker run -p 8082:8082 --rm -it postmanager:development
```

Запуск Production
```bash
docker run -p 8081:8081 --rm -it postmanager:latest
```

### Application
#### Запуск среды
Выбор необходимой среды в приложении производится следующим образом
```python
if (os.environ.get('FLASK_ENV', 'development') == 'development'):
    app.run(host='0.0.0.0', port=(
        os.environ.get('APP_PORT', 8080)), debug=True)
else:
    from waitress import serve
    serve(app, host="0.0.0.0", port=(
        os.environ.get('APP_PORT', 8080)))
```
#### Используемые зависимости
```bash
Flask~=2.0.2
SQLAlchemy~=1.4.27
Flask-SQLAlchemy~=2.5.1
Flask-RESTful~=0.3.9
Flask-CORS~=3.0.10
# При использовании Postgresql в PyCharm необходимо раскомментировать следующую строку
# psycopg2~=2.9.2
waitress~=2.0.0
```
#### Внешний вид
![App](images/app.png)

#### Выбор базы данных

##### sqlite

```python
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///{}".format(DATABASE_FILE)
```

##### postgresql

Application
```python
app.config["SQLALCHEMY_DATABASE_URI"] = (os.environ.get('DATABASE_URI', 'postgresql://postgres:password@127.0.0.1/'))
```

Dockerfile
```Dockerfile
DATABASE_URI='postgresql://postgres:password@127.0.0.1/'
```