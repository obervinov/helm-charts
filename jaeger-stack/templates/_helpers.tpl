{{/*
Expand the name of the chart.
*/}}
{{- define "jaeger.name" -}}
{{-   default .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "jaeger.chart" -}}
{{-   printf "%s-%s" .Release.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "jaeger.labels" -}}
helm.sh/chart: {{ include "jaeger.chart" . }}
{{-   if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{-   end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "collector.name" -}}
{{-   printf "%s" .Values.collector.name }}
{{- end }}

{{- define "collector.fullname" -}}
{{-   printf "%s-%s" .Release.Name .Values.collector.name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "agent.name" -}}
{{-   printf "%s" .Values.agent.name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "agent.fullname" -}}
{{-   printf "%s-%s" .Release.Name .Values.agent.name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "query.name" -}}
{{-   printf "%s" .Values.query.name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "query.fullname" -}}
{{-   printf "%s-%s" .Release.Name .Values.query.name | trunc 63 | trimSuffix "-" }}
{{- end }}
