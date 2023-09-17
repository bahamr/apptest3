FROM maven:3.6.3-jdk-11-slim
COPY /home/ec2-user/apptest3 .
COPY src /app/src
COPY pom.xml /app
RUN mvn -f /app/pom.xml clean package

RUN mv /app/target/*.jar app.jar

ENTRYPOINT ["java","-jar","/app.jar"]
