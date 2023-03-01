{{/*
Expand the name of the chart.
*/}}
{{- define "proxy.name" -}}
    {{- .Values.name | trunc 63 | trimSuffix "-" }}
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
helm.sh/chart: {{ .Chart.Name }}
helm.sh/version: {{ .Chart.Version }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "proxy.selectorLabels" -}}
appselector: {{ include "proxy.name" $ }}
{{- end }}