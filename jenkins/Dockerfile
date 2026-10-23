# Jenkins « simple » de la formation Initiation : un conteneur, zero agent.
# Ajouts : git + Maven (builds), docker CLI (images via le socket hote),
# Trivy (scan de vulnerabilites, binaire copie depuis l'image officielle).
FROM jenkins/jenkins:lts-jdk21

COPY --from=aquasec/trivy:0.58.1 /usr/local/bin/trivy /usr/local/bin/trivy

USER root
RUN apt-get update \
 && apt-get install -y --no-install-recommends git maven ca-certificates curl gnupg \
 && install -m 0755 -d /etc/apt/keyrings \
 && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
 && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
      https://download.docker.com/linux/debian $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
      > /etc/apt/sources.list.d/docker.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends docker-ce-cli docker-buildx-plugin \
 && rm -rf /var/lib/apt/lists/*
USER jenkins

# Plugins : pipeline declaratif + git + rapports (tests, analyse statique, couverture)
RUN jenkins-plugin-cli --plugins "workflow-aggregator git junit warnings-ng coverage"
