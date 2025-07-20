# custom-charts

## Charts disponibles

### cronjob

- **Description** : Helm Chart CronJobs for Kubernetes
- **Version** : 1.0.0
- **AppVersion** : 0.1.3

### proxy

- **Description** : Ingress Proxy for ExternalName
- **Version** : 1.0.0
- **AppVersion** : 1.0.0

### grafana-dashboards

- **Description** : Dashboards for Grafana
- **Version** : 1.1.2
- **AppVersion** : 1.0.0

### openvpn-exporter

- **Description** : OpenVPN exporter for Prometheus
- **Version** : 1.0.0
- **AppVersion** : v0.3.2

## Utilisation du repo Helm

```sh
helm repo add custom-charts https://freuds.github.io/custom-charts
helm repo update
helm search repo custom-charts
```
