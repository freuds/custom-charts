{{/*
Chart name and version as used by the chart label
*/}}
{{- define "names.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Name of the chart, truncated at 63 chars
*/}}
{{- define "names.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Fully qualified app name, truncated at 63 chars
*/}}
{{- define "names.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Per-component fullname, e.g. <release>-thanos-query
Usage: {{ include "names.componentFullname" (dict "context" $ "component" "query") }}
*/}}
{{- define "names.componentFullname" -}}
{{- printf "%s-%s" (include "names.fullname" .context) .component | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Name of the ServiceAccount
*/}}
{{- define "names.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "names.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Chart base labels, common to every resource
*/}}
{{- define "labels.baseLabels" -}}
helm.sh/chart: {{ include "names.chart" . }}
app.kubernetes.io/name: {{ include "names.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{/*
Component selector labels (stable subset used on Service/Deployment selectors).
Usage: {{ include "labels.componentSelectorLabels" (dict "context" $ "component" "query") }}
*/}}
{{- define "labels.componentSelectorLabels" -}}
app.kubernetes.io/name: {{ include "names.name" .context }}
app.kubernetes.io/instance: {{ .context.Release.Name }}
app.kubernetes.io/component: {{ .component }}
{{- end -}}

{{/*
Full component labels = base labels + component selector label.
Usage: {{ include "labels.componentLabels" (dict "context" $ "component" "query") }}
*/}}
{{- define "labels.componentLabels" -}}
{{ include "labels.baseLabels" .context }}
app.kubernetes.io/component: {{ .component }}
{{- end -}}
