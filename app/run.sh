#!/bin/sh

while true; do
  echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n$(curl -s https://genrandom.com/cats/)" \
    | nc -l -p 8080
done