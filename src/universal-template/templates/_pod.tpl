{{/*
Pod template shared by Deployment, StatefulSet, Job and CronJob.
app.extraLabels and app.extraAnnotations go on the pod; app.extraLabels also on the workload.
Usage: include "universal-template.podTemplate" (dict "root" $ "application" $application "fullName" $fullName ["restartPolicy" "Never"])
*/}}
{{- define "universal-template.podTemplate" -}}
{{- include "universal-template.validate.pod" . -}}
metadata:
  {{- include "universal-template.metadata" (dict "root" .root "fullName" .fullName "pod" true "labels" .application.app.extraLabels "annotations" .application.app.extraAnnotations) | nindent 2 }}
spec:
  {{- include "universal-template.podSpec" . | trim | nindent 2 }}
{{- end }}


{{/*
spec of a Job, and jobTemplate.spec of a CronJob. A key that is not set takes its default; 0 is kept.
Usage: include "universal-template.jobSpec" (dict "root" $ "application" $application "fullName" $fullName "settings" $application.app.job "activeDeadlineSeconds" 600)
*/}}
{{- define "universal-template.jobSpec" -}}
{{- $settings := .settings | default dict -}}
{{- $spec     := dict -}}
{{- range $key, $default := dict "parallelism" 1 "completions" 1 "backoffLimit" 3 "activeDeadlineSeconds" .activeDeadlineSeconds "ttlSecondsAfterFinished" 300 -}}
{{-   $_ := set $spec $key (dig $key $default $settings) -}}
{{- end -}}
{{- toYaml $spec }}
template: {{- include "universal-template.podTemplate" (dict "root" .root "application" .application "fullName" .fullName "restartPolicy" (dig "restartPolicy" "Never" $settings)) | nindent 2 }}
{{- end }}


{{/*
Pod spec. Values are rendered as data (toYaml) or as quoted scalars, so no value can add keys.
*/}}
{{- define "universal-template.podSpec" -}}
{{- $app := .application.app -}}
{{- with .application.rbac }}
serviceAccountName: {{ ternary $.fullName (.useExistingServiceAccount | default "default") (.create | default false) | quote }}
{{- end }}
{{- with $app.imagePullSecrets }}
imagePullSecrets:
  {{- range . }}
  - name: {{ . | quote }}
  {{- end }}
{{- end }}
{{- with $app.affinity }}
affinity: {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $app.nodeSelector }}
nodeSelector: {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $app.tolerations }}
tolerations: {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $app.initContainers }}
initContainers:
  {{- range . }}
  - {{ include "universal-template.container" . | nindent 4 | trim }}
  {{- end }}
{{- end }}
containers:
  {{- range $app.containers }}
  - {{ include "universal-template.container" . | nindent 4 | trim }}
  {{- end }}
{{- with include "universal-template.volumes" . | fromYamlArray }}
volumes: {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .restartPolicy }}
restartPolicy: {{ . | quote }}
{{- end }}
{{- end }}


{{/*
One container. Keys that are unset or empty are left out.
Usage: include "universal-template.container" $container
*/}}
{{- define "universal-template.container" -}}
{{- $container := dict "name" .name "image" (printf "%s:%v" .image.repository .image.tag) "imagePullPolicy" (.image.pullPolicy | default "IfNotPresent") -}}
{{- $optional := merge (pick . "ports" "lifecycle" "securityContext" "resources" "volumeMounts") (.probes | default dict) -}}
{{- $_ := merge $optional (dict "env" .envs "command" (.image.commands | default list | toStrings) "args" (.image.args | default list | toStrings)) -}}
{{- range $key, $value := $optional -}}
{{-   if $value -}}
{{-     $_ := set $container $key $value -}}
{{-   end -}}
{{- end -}}
{{- toYaml $container -}}
{{- end }}


{{/*
Volumes of the pod, as a YAML list: the chart's ConfigMap/Secret under the reserved names
volume-configs/volume-secrets (only when the chart renders them), then app.volumes as is.
A container mounts them only by listing them in its volumeMounts.
Usage: include "universal-template.volumes" (dict "application" $application "fullName" $fullName)
*/}}
{{- define "universal-template.volumes" -}}
{{- $volumes := list -}}
{{- $items := list -}}
{{- range (dig "configMap" "files" list .application) -}}
{{-   if .data -}}
{{-     $items = append $items (dict "key" .name "path" .name) -}}
{{-   end -}}
{{- end -}}
{{- with $items -}}
{{-   $volumes = append $volumes (dict "name" "volume-configs" "configMap" (dict "name" $.fullName "items" .)) -}}
{{- end -}}
{{- if dig "secret" "data" "" .application -}}
{{-   $volumes = append $volumes (dict "name" "volume-secrets" "secret" (dict "secretName" .fullName)) -}}
{{- end -}}
{{- toYaml (concat $volumes (.application.app.volumes | default list)) -}}
{{- end }}
