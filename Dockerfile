from openjdk:8-jre-alpine
RUN 	apk --no-cache add wget curl;\
COPY ["scripts/install.sh", "install.sh"]

ENTRYPOINT ["install.sh"]
