docker build -t "rrm_php:8.2" .
docker run --name "rrm_php" -it -p 8080:80 "rrm_php:8.2"