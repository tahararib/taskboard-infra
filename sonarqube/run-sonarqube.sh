#!/usr/bin/env bash
# SonarQube Community — composant du MASTER pour la démo du Ch.6 (dashboard lu en séance).
# ⚠ Gourmand : prévoir ~3-4 Go de RAM et 1-3 min de démarrage → PRÉ-DÉMARRÉ dans le master,
#   jamais lancé en séance. À mesurer au dry run (empreinte réelle sur poste IB).
set -euo pipefail

docker volume create sonarqube_data >/dev/null
docker volume create sonarqube_logs >/dev/null
docker volume create sonarqube_extensions >/dev/null

docker rm -f sonarqube >/dev/null 2>&1 || true
docker run -d --name sonarqube --restart unless-stopped \
  -p 9000:9000 \
  -v sonarqube_data:/opt/sonarqube/data \
  -v sonarqube_logs:/opt/sonarqube/logs \
  -v sonarqube_extensions:/opt/sonarqube/extensions \
  sonarqube:community

echo "SonarQube : http://localhost:9000  (admin/admin au premier démarrage, changement imposé)"
echo ""
echo "── Préparation du master : peupler le dashboard pour la démo du Ch.6 ──"
echo "  1. Se connecter, créer un token : My Account → Security → Generate Token"
echo "  2. Lancer UNE analyse de taskboard (le dashboard de démo sera peuplé) :"
echo "     cd ~/taskboard && mvn -B sonar:sonar \\"
echo "       -Dsonar.host.url=http://localhost:9000 -Dsonar.token=VOTRE_TOKEN"
echo ""
echo "── Extension « pour aller plus loin » (Atelier 4) : stage optionnelle ──"
echo "  stage('Analyse SonarQube') { steps { sh 'mvn -B sonar:sonar \\"
echo "    -Dsonar.host.url=http://host.docker.internal:9000 -Dsonar.token=\$SONAR_TOKEN' } }"
echo "  (depuis le conteneur Jenkins, SonarQube se joint via host.docker.internal)"
