#FROM zhuyaliang/base-image:21
FROM zhuyaliang/base-image:21
MAINTAINER mouse "15132211195@163.com" 
RUN yum install nginx -y
RUN rm -rf /usr/share/nginx/html/*
#ADD global.conf /etc/nginx/conf.d/
ADD nginx.conf /etc/nginx/nginx.conf
EXPOSE 80

