FROM jenkins/jenkins
USER root
COPY plugins.txt /usr/share/jenkins/plugins/
RUN  jenkins-plugin-cli -f /usr/share/jenkins/plugins/plugins.txt

RUN apt-get update && apt-get install -y ca-certificates curl gnupg lsb-release apt-utils sudo \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg\
    && echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
      | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose \
    && rm -rf /var/lib/apt/lists/*

RUN usermod -aG sudo jenkins
USER jenkins
