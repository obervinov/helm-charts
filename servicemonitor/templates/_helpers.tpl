{{/*
Expand the name of the chart.
*/}}
{{- define "chart.name" -}}
{{-   .Release.Name | trunc 63 | trimSuffix "-" | lower }}
{{- end }}

{{/*
Expand the item for servicemonitor.
*/}}
{{- define "chart.fullName" -}}
{{-   $ := index . 0 }}
{{-   $item := index . 2 -}}
{{-   with index . 1 }}
{{-     $name := include "chart.name" $ -}}
{{-     printf "%s-%s-servicemonitor" $name $item }}
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
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
app.kubernetes.io/version: "{{ replace "+" "_" .Chart.Version }}"
helm.sh/chart: {{ .Chart.Name | quote }}
helm.sh/version: {{ .Chart.Version | quote }}
heritage: {{ $.Release.Service | quote }}
app: {{ .Release.Name | quote }}
release: "kube-prometheus-stack"
jobLabel: {{ .Release.Name | quote }}
{{- end }}
