
# Бэкенд для web приложения Currencies.

#
##### Для запуска web приложения Currencies необходимо выполнить следующие шаги:
* создать папку (например `currencies`)
    ```
    ~$ mkdir ./currencies && cd ./currencies`
    ```
* в созданную папку скачать приложения: `currencies-backend`, `currencies-frontend`
    ```
    ~/currencies$ git clone https://github.com/avtor022/currencies-backend.git
    ~/currencies$ git clone https://github.com/avtor022/currencies-frontend.git
    ```
* установить зависимости:
    ```
    ~/currencies$ cd ./currencies-backend && bundle install && rake db:migrate
    ~/currencies$ cd ./currencies-frontend && npm install
    ```
* запуск приложения осуществляется с `/currencies-backend`
    ```
    ~/currencies$ cd ./currencies-backend && foreman start
    ```
#
#
##### Запуск тестов
  ```
  ~/currencies/currencies-backend$ rspec
  ```