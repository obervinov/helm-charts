{{/*
Expand the name of the chart.
*/}}
{{- define "chart.name" -}}
{{-   .Release.Name | trunc 63 | trimSuffix "-" | lower }}
{{- end }}

{{/*
Expand the item for servicemonitor or podmonitor.
*/}}
{{- define "chart.fullName" -}}
{{-   $ := index . 0 }}
{{-   $item := index . 2 -}}
{{-   with index . 1 }}
{{-     $name := include "chart.name" $ -}}
{{-     printf "%s-%s" $name $item }}
{{-   end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "chart.chart" -}}
{{-   printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "chart.labels" -}}
app.kubernetes.io/component: metrics
app.kubernetes.io/instance: kube-prometheus-stack
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/name: prometheus-node-exporter
app.kubernetes.io/part-of: prometheus-node-exporter
app.kubernetes.io/version: "{{ replace "+" "_" .Chart.Version }}"
helm.sh/chart: {{ .Chart.Name | quote }}
helm.sh/version: {{ .Chart.Version | quote }}
heritage: {{ $.Release.Service | quote }}
release: kube-prometheus-stack
app: {{ .Release.Name | quote }}
{{- end }}
