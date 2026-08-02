# thanos

![Version: 0.1.1](https://img.shields.io/badge/Version-0.1.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.42.4](https://img.shields.io/badge/AppVersion-v0.42.4-informational?style=flat-square)

Thanos Query, Store Gateway and Compactor for long-term Prometheus storage on S3-compatible object storage

**Homepage:** <https://thanos.io/>

## Source Code

* <https://github.com/thanos-io/thanos>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| commonLabels | object | `{}` | Extra labels for all resources created by this chart |
| compactor.enabled | bool | `true` | Deploy the Thanos Compactor (compaction, downsampling, retention enforcement on the bucket). Never scale this beyond 1 replica: the compactor is not safe to run concurrently against the same bucket. |
| compactor.extraArgs | list | `[]` | Extra flags appended to the compact command |
| compactor.logLevel | string | `"info"` |  |
| compactor.persistence | object | `{"size":"20Gi","storageClassName":"local-path"}` | Scratch disk for downloading blocks during compaction/downsampling. Needs real capacity (sized after the largest blocks compacted at once), unlike storegateway's index-only cache. |
| compactor.resources.limits.memory | string | `"1Gi"` |  |
| compactor.resources.requests.cpu | string | `"100m"` |  |
| compactor.resources.requests.memory | string | `"256Mi"` |  |
| compactor.retention.fiveMinutes | string | `"180d"` | How long 5m-downsampled blocks are kept in the bucket |
| compactor.retention.oneHour | string | `"0d"` | How long 1h-downsampled blocks are kept in the bucket ("0d" == forever) |
| compactor.retention.raw | string | `"30d"` | How long raw-resolution blocks are kept in the bucket |
| compactor.service.httpPort | int | `10902` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"quay.io/thanos/thanos"` | Official upstream Thanos image, independent of Bitnami's chart/image distribution |
| image.tag | string | `"v0.42.4"` |  |
| nameOverride | string | `""` |  |
| objstoreSecret | object | `{"key":"objstore.yml","name":"thanos-objstore-secret"}` | Reference to an existing Secret holding the objstore.yml file used by Store Gateway and Compactor to talk to the S3-compatible bucket (populated out-of-band, e.g. via an ExternalSecret synced from Vault -- see docs/thanos.md in the mediaserver repo) |
| podSecurityContext.fsGroup | int | `65534` |  |
| podSecurityContext.runAsGroup | int | `65534` |  |
| podSecurityContext.runAsNonRoot | bool | `true` |  |
| podSecurityContext.runAsUser | int | `65534` |  |
| podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| query.enabled | bool | `true` | Deploy the Thanos Query component (unified PromQL endpoint over the sidecar + store gateway) |
| query.extraStores | list | `[]` | Extra `--endpoint` targets, in addition to sidecarDiscoveryService and the in-chart store gateway |
| query.logLevel | string | `"info"` |  |
| query.replicaCount | int | `1` |  |
| query.resources.limits.memory | string | `"256Mi"` |  |
| query.resources.requests.cpu | string | `"50m"` |  |
| query.resources.requests.memory | string | `"64Mi"` |  |
| query.service.grpcPort | int | `10901` |  |
| query.service.httpPort | int | `10902` |  |
| query.sidecarDiscoveryService | string | `"kube-prometheus-stack-thanos-discovery.kube-prometheus-stack.svc.cluster.local:10901"` | DNS name (host:port, gRPC) of the kube-prometheus-stack Thanos sidecar discovery Service. Default assumes the kube-prometheus-stack release name is "kube-prometheus-stack" in the "kube-prometheus-stack" namespace (fullname collapses to the release name since it already contains the chart name) -- verify with:   kubectl get svc -n kube-prometheus-stack -l 'app.kubernetes.io/name=kube-prometheus-stack-thanos-discovery' -o name |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` | Specifies whether a ServiceAccount should be created |
| serviceAccount.name | string | `""` |  |
| serviceMonitor.enabled | bool | `false` | Requires the Prometheus Operator CRDs (already installed by kube-prometheus-stack) |
| serviceMonitor.interval | string | `"1m"` |  |
| serviceMonitor.labels | object | `{}` |  |
| serviceMonitor.namespace | string | `""` |  |
| serviceMonitor.path | string | `"/metrics"` |  |
| serviceMonitor.scheme | string | `"http"` |  |
| storegateway.enabled | bool | `true` | Deploy the Thanos Store Gateway (serves historical blocks from the bucket over the Store API) |
| storegateway.logLevel | string | `"info"` |  |
| storegateway.persistence | object | `{"size":"10Gi","storageClassName":"local-path"}` | Local scratch space for the block index-header cache. Small compared to the bucket itself: only index headers are cached on disk, not full block data. |
| storegateway.replicaCount | int | `1` |  |
| storegateway.resources.limits.memory | string | `"512Mi"` |  |
| storegateway.resources.requests.cpu | string | `"50m"` |  |
| storegateway.resources.requests.memory | string | `"128Mi"` |  |
| storegateway.service.grpcPort | int | `10901` |  |
| storegateway.service.httpPort | int | `10902` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
