{{/*
Secrets template
*/}}
{{- define "universal-template.secrets.template" -}}
{{-   $ := index . 0 }}
{{-   $fullName := index . 2 }}
{{-   $type := index . 3 }}
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  labels:
    {{- include "universal-template.labels" $ | nindent 4 }}
    {{- include "universal-template.selectorLabels" (list $fullName) | nindent 4 }}
  {{- if eq $type "applications" }}
  name: {{ $fullName }}-secret
  {{- else if eq $type "jobs" }}
  name: {{ $fullName }}-job-secret
  {{- else if eq $type "cronjobs" }}
  name: {{ $fullName }}-cronjob-secret
  {{- end }}
  namespace: {{ $.Release.Namespace }}
data:
{{-   with index . 1 }}
{{-     range $key, $value := fromYaml .secret.data }}
  {{ $key }}: {{ $value | b64enc }}
{{-     end }}
{{-   end }}
{{- end }}