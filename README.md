# taskboard-infra — l'infrastructure du fil rouge (Initiation 2J)

Deux repos, deux responsabilités : le **code** vit dans `taskboard`,
l'**infrastructure** vit ici — c'est le socle du modèle GitOps du Lab 4.

| Dossier | Contenu | Utilisé au |
|---|---|---|
| `chart/` | chart Helm de l'application (deployment + service + ingress + secret) | Labs 2 et 4 |
| *(postgres : intégré au chart)* | PostgreSQL du namespace cible (appliqué une fois) | Lab 2 |
| `argocd/application.yaml` | l'Application ArgoCD qui observe CE repo | Lab 4 |
| `observabilite/` | Prometheus + Grafana pré-provisionnés (datasource + dashboard) | Atelier 3 |
| `jenkins/` | le Jenkins de formation (image + script de lancement) — composant du master | hors ateliers |
| `sonarqube/` | SonarQube de démo (pré-démarré et pré-analysé dans le master) | Ch.6 (démo) |

Accès à l'application déployée : `http://taskboard.localhost` (Ingress Traefik du cluster k3d).
