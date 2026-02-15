FROM eclipse-temurin:17-jdk-alpine
RUN addgroup -S bookstore && adduser -S bookstore -G bookstore && mkdir -p /opt/bookstore
WORKDIR /opt/bookstore
COPY target/bookstore-springboot-mysql-9739110917.jar app.jar
COPY startup.sh startup.sh
RUN chown -R bookstore:bookstore /opt/bookstore
USER bookstore
EXPOSE 8080
ENTRYPOINT ["./startup.sh"]


