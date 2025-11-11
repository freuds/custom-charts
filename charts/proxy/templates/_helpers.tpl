{{/*
Expand the name of the chart.
*/}}
{{- define "proxy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "proxy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "proxy.labels" -}}
helm.sh/chart: {{ include "proxy.chart" . }}
{{ include "proxy.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "proxy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "proxy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "proxy.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "proxy.name" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Validate that the user did not enable both Ingress and Gateway exposure at the same time.
This template will fail the render if both are enabled to avoid accidentally creating both resources.
*/}}
{{- define "proxy.validateExpose" -}}
{{- /* Fail when both legacy booleans enabled */ -}}
{{- if and .Values.ingress.enabled .Values.gateway.enabled }}
	{{- fail "Configuration invalid: both .Values.ingress.enabled and .Values.gateway.enabled are true. Please enable only one exposure method (Ingress OR Gateway)." -}}
{{- end }}

{{- /* If user uses new expose.type and also set legacy booleans, forbid mixing */ -}}
{{- if and (ne (default "" .Values.expose.type) "") (or .Values.ingress.enabled .Values.gateway.enabled) }}
	{{- fail "Configuration invalid: .Values.expose.type is set; do not set .Values.ingress.enabled or .Values.gateway.enabled when using expose.type." -}}
{{- end }}

{{- /* Validate expose.type value if set */ -}}
{{- if ne (default "" .Values.expose.type) "" }}
	{{- $t := lower .Values.expose.type }}
	{{- if not (or (eq $t "ingress") (eq $t "gateway")) }}
		{{- fail (printf "Configuration invalid: .Values.expose.type must be one of 'ingress' or 'gateway' (got '%s')" .Values.expose.type) -}}
	{{- end }}
{{- end }}
{{- end }}


{{- /* Return effective expose method: priority is expose.type if set, else legacy booleans */ -}}
{{- define "proxy.exposeMethod" -}}
{{- $et := default "" .Values.expose.type }}
{{- if ne $et "" }}
	{{- lower $et -}}
{{- else if .Values.ingress.enabled }}
	ingress
{{- else if .Values.gateway.enabled }}
	gateway
{{- else -}}
	{{- "" -}}

{{- end }}
{{- end }}
