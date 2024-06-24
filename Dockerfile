FROM tomcat:9.0

RUN rm -rf /usr/Local/tomcat/webapps/*
COPY target/biller-project-services-front-1.0-SNAPSHOT.war /usr/Local/tomcat/webapps/ROOT.war

CMD ["catalina.sh", "run"]