FROM nginx:alpine
RUN echo 'server { \
    listen 80; \
    location /health { \
        return 200 "OK"; \
    } \
    location / { \
        return 200 "Hello World"; \
    } \
}' > /etc/nginx/conf.d/default.conf
