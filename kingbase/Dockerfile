FROM docker.isoft.zhcn.cc/zhuyaliang/base-image:isoft
MAINTAINER zhuyaliang 15132211195@163.com

ENV USERNAME SYSTEM
ENV PASSWORD 123456
RUN groupadd kingbase &&  useradd -d /home/kingbase -g kingbase -m kingbase 
COPY KingbaseES /home/kingbase/KingbaseES
RUN mkdir /home/kingbase/data -p && mkdir /home/kingbase/log -p && ln -s /lib64/libodbc.so.2.0.0 /lib64/libodbc.so.1
VOLUME /home/kingbase/data
VOLUME /home/kingbase/log
WORKDIR /home/kingbase/
EXPOSE 54321
ENTRYPOINT /home/kingbase/KingbaseES/start.sh

