docker-compose down
docker system prune -a
docker volume prune -a
docker network prune
docker-compose up -d --build