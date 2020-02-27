FROM registry.access.redhat.com/ubi8/ubi-minimal

ENV APPDIR=/opt/helloworld

ADD target/helloworld.jar $APPDIR/helloworld.jar

RUN microdnf install shadow-utils && \
    microdnf install java-1.8.0-openjdk-headless && \
    microdnf update && \
    adduser myuser && \
    chmod -R a+rwx $APPDIR && \
    microdnf remove shadow-utils && \
    microdnf clean all

USER myuser

CMD ["/bin/bash", "-c", "java -jar $APPDIR/helloworld.jar"]
