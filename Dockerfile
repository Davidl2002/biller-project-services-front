FROM tomcat:9.0

RUN rm -rf /usr/Local/tomcat/webapps/*
COPY *.war /usr/Local/tomcat/webapps

CMD ["catalina.sh", "run"]