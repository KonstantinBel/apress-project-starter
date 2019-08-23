# Скрипт для запуска/перезапуска проектов Абак-пресс

- В PROJECT_PATH необходимо прописать абсолютный путь к папке с проектами.
- Файл скрипта abak_projects сделать исполняемым.
- Сделать скрипт доступным из любых директорий: `echo PATH=$PATH:/path/to/dir/apress-project-starter >> ~/.bashrc`

`abak_projects $action $project $target`

## Доступные действия ($action):
     - start - просто запустит dip rails s
     - restart - остановит сервер, поднимет resque и зпустит dip rails s
     - reset - остановит сервер, установит гемы, сделает миграции, обновит npm пакеджи
     - down - останавливает все проекты
     - debug - подключаемя к контейнеру приложения
     - debug_front - смотрим логи вебпака

## Доступные проекты ($project):
     - bz - blizko
     - pc - pulscen
     - cs - cosmos
     - dk - dk

## Доступные цели для Космоса ($target)
     - bz - blizko
     - pc - pulscen

## Пример запуска (можно выполнять из любой директории):
- Полный перезапуск Близко с установкой гемов - `abak_projects.sh reset bz`
- Запуск Космос для Близко - `abak_projects.sh start cs bz`
- Отлаживаем Близку - `abak_projects.sh debug bz`
