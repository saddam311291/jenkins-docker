FROM jenkins/jenkins:lts

USER root

COPY jdk-17.0.12_linux-x64_bin.tar.gz /opt/

RUN mkdir /opt/jdk17 && \
    tar -xzf /opt/jdk-17.0.12_linux-x64_bin.tar.gz -C /opt/jdk17 --strip-components=1 && \
    rm /opt/jdk-17.0.12_linux-x64_bin.tar.gz

ENV JAVA_HOME=/opt/jdk17
ENV PATH=$JAVA_HOME/bin:$PATH
############# 
# Install Docker CLI (only the client)
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install -y docker-ce-cli && \
    apt-get clean

# Add Jenkins user to docker group (if docker group added as discussed)
ARG DOCKER_GID=999
RUN groupadd -g ${DOCKER_GID} docker || true && usermod -aG docker jenkins
##############

USER jenkins
