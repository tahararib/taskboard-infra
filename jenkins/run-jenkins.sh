#!/usr/bin/env bash
# Construit et lance le Jenkins de formation (composant du master image).
# Carte des ports v3 : Jenkins 8080 · taskboard 8081 · ArgoCD 8443 · registre 5000.
set -euo pipefail
cd "$(dirname "$0")"

docker build -t jenkins-formation:lts .
docker volume create jenkins_home >/dev/null

DOCKER_GID=$(stat -c '%g' /var/run/docker.sock)

docker rm -f jenkins >/dev/null 2>&1 || true
docker run -d --name jenkins --restart unless-stopped \
  -p 8080:8080 \
  --group-add "${DOCKER_GID}" \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins-formation:lts

echo "Jenkins démarre : http://localhost:8080"
echo "Mot de passe initial :"
echo "  docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword"
echo ""
echo "── Préparation du master (une fois, APRÈS le premier démarrage) ──"
echo "  1. Pré-charger la base de vulnérabilités Trivy (~900 Mo, le lab utilise --skip-db-update) :"
echo "     docker exec jenkins trivy image --download-db-only"
echo "  2. Créer le job Pipeline « taskboard » (Pipeline script from SCM → dépôt du participant)"
echo "  3. Vérifier que l'image taskboard passe le scan bloquant du lab :"
echo "     docker exec jenkins trivy image --skip-db-update --severity CRITICAL --ignore-unfixed localhost:5000/taskboard:dev"
