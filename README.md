# Тестовое задание для собеседования в компанию Effective Mobile
***

#[![Build](https://img.shields.io/badge/Build-stable-!)](https://hub.docker.com/layers/olejean/app-diplom/v1.0.5/images/sha256-523a57783bfd398b085bbca356e952e6b1d65ccc95c5c23fd467223fe702dd4b?context=repo)
#####  В проекте используется ряд иструменнов с открытым исходным кодом :
- [Ansible](https://www.ansible.com/) - Управление конфигурацией и развертывание приложений, на множество серверов.
- [GitHub](https://github.com/olejean/devops-diplom) - GitHub — крупнейший веб-сервис для хостинга IT-проектов и их совместной разработки.
- [Docker-compose](https://www.docker.com/)
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

![Alt text](test_task/bd.png)
***
## Решение
Из задания, я так понял, что нужно сделать докеризированное веб приложение (nginx, php, mysql) -- тоесть в одном докер контейнере, хоть это конечно не правльно, потому что нужно стремиться к: один контейнер один процесс. Возможно я что-то не правильно понял, но я так понимаю вы оцениваете всетаки мои знания, поэтому издагаю мысли.
Порты в контейнере заменены на 8080  так как запускать контейнеры с портами меньше 1024   НЕ  безопасно. HTTPS ssl  делать не стал, так как в задании это не указано.
Коментировать каждую строчку в конфигах не стал, но вы можете спросить на собеседовании -- отвечу за каждую строчку)

Пересчитаем конфиг после изменения конфигурационного файла, зачем рестартовать если можно пересчитать.

 
#### Пишем Dockerfile

- Разворачиваем  три инстанса.  Два сервера в одном кластере Kubernetes: 1 master (Managed Service for Kubernetes) и одна нода (Node) app 
-  Сервер srv для инструментов мониторинга, логгирования и сборок контейнеров.
#### installation
Основной файл [README.md](https://github.com/olejean/devops-diplom/blob/main/README.md)   находится в этом Репозиторий.
Клонируем репозиторий  https://github.com/olejean/devops-diplom.git Переходим в папку terraform и запускаем terraform apply  -var-file=secret.tfvars
Все секретные данные находится в отдельно файле и в git  не попали. Готово наша инфрастуктура развернута.


```sh
git pull https://github.com/olejean/devops-diplom.git
cd ~/devops-diplom/terraform/
terraform apply  -var-file=secret.tfvars
```

Устанавливаем Ansible  на сервер srv, что бы с него можно было автоматизировать установку приложений. переходим а папку ansible  и запускаем.
___Устанавливаем приложения необходимые для работы___
- Kubectl
- Helm
- Prometheus
- Docker
- net-tools
- gitlab-runner
```
apt install ansible
cd ~/devops-diplom/ansible
ansible-playbook playbook_all.yml -i hosts
```
__Отдельно установим в кластер:__
- Устанавливаем ALB Ingress Controller 
- Создадим DNS  зону в yandex cloud на домен olejean.ru (предварительно делигировав dns от -   регистратора к YC) Приложение будет доступно по адресу app.infra.olejean.ru
    

    

### 2. Cобираем, деплоим наше приложение  настраиваем CI/CD
Клонируем репозиторий, собираем его на сервере srv.

Регистрируем gitlab-runner  на сервере srv
```
sudo gitlab-runner register --url https://gitlab.com/ --registration-token <token>
```    

Настраиваем доступ к docker-hub для хранения образов созданных с помошью пайплана gitlab-ci
```
docker login -u olejean
```

Клонируем наше приложение на сервер srv
```
git clone https://gitlab.com/olejean/diplom-app2.git

```
__Настраиваем CI/CD - Описываем .gitlab-ci.yml__
- Первая стадия будет build - будет собирать образ и отправлять его на dockerhub olejean/app-diplom:tagname
- вторая стадия deploy  будет разворичивать приложение через Help  на наш кластер Kebernetes.



__Подключаем сертификаты__
- Воспользуюсь сервисом Yandex Certificate Manager.
- Создадим сертификат на доменное имя,  для приложения app.infra.olejean.ru

### 3. Разворачивакем мониторинг 
- Клонируем репозиторий с мониторингом и запускаем сначала через docker compose - prometheus  
```
git clone git@github.com:olejean/monitoring-diplom.git
cd prometheus/
docker compose up -d
```

- Далее развернем grafana-loki Так как у нас есть grafanf добавим в нее loki  
- Отдельно установим в кластер kubernetes promtail для отправки логов через Helm
```
helm install promtail --create-namespace promtail ./promtail
```



