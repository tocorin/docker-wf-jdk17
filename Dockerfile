FROM bellsoft/liberica-openjdk-alpine:17.0.9
ENV LANG=ru_RU.UTF-8
ENV LANGUAGE=ru_RU.UTF-8:ru

ENV WILDFLY_VERSION 30.0.1.Final
ENV JBOSS_HOME /opt/jboss/wildfly

RUN addgroup -g 1000 -S jboss  && adduser -u 1000 -S -G jboss -h /opt/jboss -s /sbin/nologin  jboss

USER root

COPY wildfly-${WILDFLY_VERSION} ${JBOSS_HOME}

RUN chown -R jboss:0 ${JBOSS_HOME} && chmod -R g+rw ${JBOSS_HOME}

RUN ${JBOSS_HOME}/bin/add-user.sh -u 'admin' -p 'admin' --silent

# Ensure signals are forwarded to the JVM process correctly for graceful shutdown
ENV LAUNCH_JBOSS_IN_BACKGROUND true

USER jboss

# Expose the ports in which we're interested
EXPOSE 8080 
EXPOSE 9990

CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-c", "standalone-full.xml"]