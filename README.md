# custom-charts

Ce dépôt contient des charts Helm personnalisés, packagés et publiés automatiquement.

## Structure du dépôt

- `charts/` : Contient les charts Helm
  - `cronjob/` : Chart Helm pour déployer des CronJobs Kubernetes
  - `gatus/` : Chart Helm pour déployer [Gatus](https://github.com/TwiN/gatus) webservice
  - `grafana-dashboards/` : Chart Helm pour déployer des dashboards Grafana en tant que ConfigMaps
  - `ihm/` : Chart Helm pour des webservices génériques
  - `openvpn-exporter/` : Chart Helm pour exporter les métriques OpenVPN à Prometheus
  - `proxy/` : Chart Helm pour déployer un Ingress multi-ProxyPass
  - `ct.yaml` : Configuration Chart Testing (lint, validation)
  - `lintconf.yaml` : Règles de lint YAML
- `docs/` : Contient les packages Helm générés (`.tgz`) et l'index du repo Helm (`index.yaml`)
- `Taskfile.yml` : Tâches pour automatiser le lint, la génération et la validation
- `.github/workflows/helm-release.yaml` : CI GitHub Actions pour packager et publier les charts

## Déclaration d'un nouveau chart

Il suffit de le déclarer dans le fichier `charts/ct.yaml` pour qu'il soit pris en compte.

## Automatisation CI

À chaque push sur `main`, les charts sont automatiquement packagés dans `docs/` et l'`index.yaml` est mis à jour. Le repo Helm est ainsi prêt à être utilisé comme source externe.

## Utilisation du repo Helm

```sh
helm repo add custom-charts https://freuds.github.io/custom-charts
helm repo update
helm search repo custom-charts
```

## Lint et validation locale

```sh
task lint-all
```

## Générer les packages localement

```sh
task generate
```

---
