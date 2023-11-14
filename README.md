# Дипломный проект по курсу Devops

##  Создаем инфраструктуру как код (iaC) через terraform
### 1. Разворациваем инфрастуктуру три инстанса в Yandex Cloud  
    -  два сервера в одном кластере Kubernetes: 1 master (Managed Service for Kubernetes) и одна нода - app
    -  сервер srv для инструментов мониторинга, логгирования и сборок контейнеров.
     
     Скачиваем репозиторий https://github.com/olejean/devops-diplom.git Переходим в папку terraform и запускаем terraform plan -destroy  -var-file=secret.tfvars
       Все секретные данные находится в отдельно файле и в git  не попали. Готово наша инфрастуктура развернута.
     Устанавливаем ansible  на сервер srv, что бы с него можно было автоматизировать установку приложений. 
     
### 2. Cобираем, деплоим наше приложение  настраиваем CI/CD 
    - Клонируем репозиторий, собираем его на сервере srv.
          
     

