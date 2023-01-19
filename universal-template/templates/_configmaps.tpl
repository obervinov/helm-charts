{{/*
Secrets template
*/}}
{{- define "universal-template.configmap.template" -}}
{{-   $ := index . 0 }}
{{-   $fullName := index . 2 }}
{{-   $type := index . 3 }}
apiVersion: v1
kind: ConfigMap
metadata:
  labels:
    {{- include "universal-template.labels" $ | nindent 4 }}
    {{- include "universal-template.selectorLabels" (list $fullName) | nindent 4 }}
  {{- if eq $type "applications" }}
  name: {{ $fullName }}-cm
  {{- else if eq $type "jobs" }}
  name: {{ $fullName }}-job-cm
  {{- else if eq $type "cronjobs" }}
  name: {{ $fullName }}-cronjob-cm
  {{- end }}
  namespace: {{ default $.Release.Namespace }}
data:
{{-   with index . 1 }}
{{-     range .configmap.files }}
{{-       if .data }}
{{-         printf "%s: |-" .name | nindent 2 }} {{- printf "%s" .data | nindent 4 -}}
{{-       end }}
{{-     end }}
{{-   end }}
{{- end }}