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
Expand the appPrefix for cronjobs.
*/}}
{{- define "universal-template.fullName.cronjobs" -}}
{{-   $ := index . 0 }}
{{-   $appPrefix := index . 2 -}}
{{-   with index . 1 }}
{{-     $name := include "universal-template.name" $ -}}
{{-     if gt (len $.Values.cronjobs) 1 }}
{{-        printf "%s-%s" $name $appPrefix }}
{{-     else }}
{{-         printf "%s" $name }}
{{-     end }}
{{-   end }}
{{- end }}


{{/*
Expand the appPrefix for jobs.
*/}}
{{- define "universal-template.fullName.jobs" -}}
{{-   $ := index . 0 }}
{{-   $appPrefix := index . 2 -}}
{{-   with index . 1 }}
{{-     $name := include "universal-template.name" $ -}}
{{-     if gt (len $.Values.jobs) 1 }}
{{-        printf "%s-%s" $name $appPrefix }}
{{-     else }}
{{-         printf "%s" $name }}
{{-     end }}
{{-   end }}
{{- end }}


{{/*
Expand the appPrefix for RBAC.
*/}}
{{- define "universal-template.fullName.rbac" -}}
{{-   $ := index . 0 }}
{{-   $appPrefix := index . 2 -}}
{{-   with index . 1 }}
{{-     $name := include "universal-template.name" $ -}}
{{-     if gt (len $.Values.rbac) 1 }}
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
helm.sh/chart: {{ .Chart.Name | quote }}
helm.sh/version: {{ .Chart.Version | quote }}
heritage: {{ $.Release.Service | quote }}
app: {{ .Release.Name | quote }}
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
Default resources limit/request
*/}}
{{- define "universal-template.resources.default" -}}
requests:
  memory: "256Mi"
  cpu: "250m"
limits:
  memory: "512Mi"
  cpu: "500m"
{{- end }}