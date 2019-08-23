# Скрипт для запуска/перезапуска проектов Абак-пресс.
#
# В PROJECT_PATH необходимо прописать абсолютный путь к папке с проектами.
# В секции "Available projects" перечислены доступные проекты.
# 
# Доступные действия:
#      - start - просто запустит dip rails s
#      - restart - остановит сервер, поднимет resque и зпустит dip rails s
#      - reset - остановит сервер, установит гемы, сделает миграции, обновит npm пакеджи
#      - down - останавливает все проекты
# 
# Пример запуска (можно выполнять из любой директории):
# Полный перезапуск Близко с установкой гемов - abak_porojects.sh reset bz 
# Запуск Космос для Близко - abak_porojects.sh start cs bz 

ACTION=${1:-'start'}       # action (start, restart, reset, down)
PROJECT=${2:-'bz'}         # project (bz - blizko, pc - pulscen, dk, cs - cosmos)
TARGET=${3:-'bz'}          # cosmos target (bz - blizko, pc - pulscen, dk, cs - cosmos)
PROJECT_PATH="/home/bartzlo/abak_porojects"

# Available projects
declare -A PROJECTS
PROJECTS['bz']='blizko'
PROJECTS['pc']='pulscen'
PROJECTS['cs']='cosmos'
PROJECTS['dk']='dk'

if [ "$ACTION" = "down" ]
then
     echo "shutdown all projects"
     sleep 0.5s

     for projectName in "${PROJECTS[@]}"; do
          cd "/home/bartzlo/abak_porojects/$projectName"
          dip compose down
     done
     exit 0
fi

projectName="${PROJECTS[$PROJECT]}"
if [ -z "$projectName" ]
then
     echo "project '$PROJECT' not found"
     exit 1
fi

# Configure specified projects env
if [ "$projectName" = "dk" ]
then
     export DOCKER_TLD="test"
fi

if [ "$projectName" = "cs" ]
then
     cosmosProject="${PROJECTS[$TARGET]}"
     if [ -z "$cosmosProject" ]
     then
          echo "target project '$PROJECT' not found"
          exit 1
     fi
     export COSMOS_PROJECT="$cosmosProject"
fi

# Show process details
echo "===================="
echo "$ACTION $projectName"
echo "===================="
sleep 0.5s

# Execute conands in project dir
cd "$PROJECT_PATH/$projectName"

case "$ACTION" in
     "start")
          dip rails s
     ;;
     "restart")
          dip compose down
          dip compose up -d "$projectName"-resque
          dip rails s
     ;;
     "reset")
          dip compose down
          dip bundle install
          dip rake db:migrate
          dip compose up -d "$projectName"-resque
          
          if [ "$projectName" != "dk" ]
          then
               dip package.json:compile
               dip yarn install
               dip yarn run linklocal
          fi

          dip rails s
     ;;
     *)
          echo "comand '$ACTION' not found"
          exit 1
     ;;
esac
