FROM nginx:latest

RUN rm -rf /var/www/nginx/html/*
COPY ./website/ /usr/share/nginx/html/

EXPOSE 80