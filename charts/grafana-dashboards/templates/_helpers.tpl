{{/*
Expand the name of the chart.
*/}}
{{- define "grafana-dashboards.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "grafana-dashboards.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "grafana-dashboards.labels" -}}
helm.sh/chart: {{ include "grafana-dashboards.chart" . }}
{{ include "grafana-dashboards.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "grafana-dashboards.selectorLabels" -}}
app.kubernetes.io/name: {{ include "grafana-dashboards.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}