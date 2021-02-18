FROM arm64v8/nginx
COPY dist /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d
EXPOSE 80
