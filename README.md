
# Тестовое задание для собеседования в компанию Effective Mobile
***


#####  В задании используется ряд иструменнов с открытым исходным кодом :
- [Ansible](https://www.ansible.com/) - Управление конфигурацией и развертывание приложений, на множество серверов.
- [GitHub](https://github.com/olejean/devops-diplom) - GitHub — крупнейший веб-сервис для хостинга IT-проектов и их совместной разработки.
- [Docker](https://www.docker.com/) - Платформа контейнеризации 
- [Docker-compose](https://www.docker.com/) - Надстройка над docker  для запуска множества контейнеров
***
## Задание 
Разработать ansible, запускающий докеризированное веб приложение (nginx, php, mysql) с использованием docker-compose.yml на удалённом сервере.
Плейбук должен
1. Дистрибьютить необходимые для работы файлы
2. Генерировать конфигурационный файл для nginx, и, по необходимости,
перезапускать его (nginx).

Результатом выполнения ТЗ является:
1. Ansible playbook (вместе с ролями и/или файлом с зависимостями, необходимыми
шаблонами);
2. docker-compose.yml;
3. Dockerfile;

![Mysql](https://github.com/olejean/test_task/blob/985f3c5fe5acdaf1fd47c2c619f2c2705fd98eb6/bd.PNG)
![alt text](https://github.com/[username![alt text](https://github.com/[username]/[reponame]/blob/[branch]/image.jpg?raw=true)]/[reponame]/blob/[branch]/image.jpg?raw=true)

![alt text](https://github.com/[olejean]/[test_task]/blob/[branch]/bd.png?raw=true)

***


## Решение

```sh
склонировать репозиторий на пк с ansible 
git clone https://github.com/olejean/test_task.git
прейти в папку с репозиторием и запустить команду
ansible-playbook -i inventory playbook.yml
```
### Структура проекта

test_task/
├── ansible.cfg
├── inventory
├── playbook.yml
├── roles/
│   ├── common/
│   │   ├── tasks/
│   │   │   └── main.yml
│   ├── docker/
│   │   ├── tasks/
│   │   │   └── main.yml
│   ├── app/
│   │   ├── tasks/
│   │   │   └── main.yml
│   │   ├── templates/
│   │   │   ├── nginx.conf.j2
│   │   │   ├── Dockerfile.j2
│   │   ├── files/
│   │   │   ├── .env
│   │   │   ├── app/файлы приложения index.php)
│   │   │   └── docker-compose.yml
│   │   ├── handlers/
│   │   │   └── main.yml


Роли разделены на три части
- common -- общая роль, тут устанавливыаются необходимые для работы программы и утилиты
    - apt-transport-https
    - ca-certificates
    - curl
    - software-properties-common

- Docker -- Роль установки docker и Docker compose

- App -- Оснавная Роль
   - В этой роли создаем необходимые директории для файла index.php  со сриптом на php  для проверки доступности базы данных mysql 
   - Создаем директорию для шаблона  конфигурации nginx.conf.j2 
   - Копируем необходимые файлы на удаленный сервер (docker-compose.yml, Dockerfile, .env)
   - Далее уже собирается образы и конейнеры с помощью docker-compose.yml (nginx + php-fpn +mysql
   - Также сделан handler (обработчик)  для пересчета конфигурации Nginx  когда меняется   конфигурация nginx.conf
 

После успешной сборки я создал таблицу в базе данных и прописал строчку с данными пользователя для проверки работаспособности mysql
![Mysql](https://github.com/olejean/test_task/blob/985f3c5fe5acdaf1fd47c2c619f2c2705fd98eb6/bd.PNG)



Порты в контейнере заменены на 8080  так как запускать контейнеры с портами меньше 1024   НЕ  безопасно. HTTPS ssl  делать не стал, так как в задании это не указано, но могу конечно сделать.
Коментировать каждую строчку в конфигах не стал, но вы можете спросить на собеседовании -- отвечу за каждую строчку)





