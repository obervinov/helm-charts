{{/*
Expand the name of the chart.
*/}}
{{- define "universal-template.name" -}}
{{-   .Release.Name | trunc 63 | trimSuffix "-" | lower }}
{{- end }}


{{/*
Expand the appPrefix for applications.
*/}}
{{- define "universal-template.fullName" -}}
{{-   $ := index . 0 }}
{{-   $appPrefix := index . 2 -}}
{{-   with index . 1 }}
{{-     $name := include "universal-template.name" $ -}}
{{-     if gt (len $.Values.applications) 1 }}
{{-        printf "%s-%s" $name $appPrefix }}
{{-     else }}
{{-         printf "%s" $name }}
{{-     end }}
{{-   end }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "universal-template.chart" -}}
{{-   printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Common labels
*/}}
{{- define "universal-template.labels" -}}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
app.kubernetes.io/version: "{{ replace "+" "_" .Chart.Version }}"
app: {{ .Release.Name | quote }}
version: {{ .Chart.Version | quote }}
{{- end }}


{{/*
Selector labels
*/}}
{{- define "universal-template.selectorLabels" -}}
{{-   $fullName := index . 0 -}}
appselector: {{ $fullName }}
{{- end }}


{{/*
Selector labels for prometheus operator
*/}}
{{- define "universal-template.prometheus.labels" -}}
release: "kube-prometheus-stack"
jobLabel: {{ .Release.Name | quote }}
{{- end }}


{{/*
Service Account
*/}}
{{- define "universal-template.serviceAccount" -}}
{{-   $fullName := index . 0 -}}
{{-   $serviceAccount := index . 1 -}}
{{-   if $serviceAccount.create -}}
serviceAccountName: {{ $fullName }}
{{-   else if $serviceAccount.useExistingServiceAccount -}}
serviceAccountName: {{ $serviceAccount.useExistingServiceAccount }}
{{-   else -}}
serviceAccountName: default
{{-   end -}}
{{- end }}
