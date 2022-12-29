{{- define "gitlab-runner.runner-env-vars" }}
{{- $ := index . 0 }}
{{- $name := index . 2 }}
{{- with index . 1 }}
- name: CI_SERVER_URL
  value: {{ include "gitlab-runner.gitlabUrl" $ }}
- name: CLONE_URL
  value: {{ default "" $.Values.global.cloneUrl | quote }}
{{- if .requestConcurrency }}
- name: RUNNER_REQUEST_CONCURRENCY
  value: {{ default 1 .requestConcurrency | quote }}
{{- end }}
- name: RUNNER_EXECUTOR
  value: {{ default "kubernetes" .executor | quote }}
- name: REGISTER_LOCKED
  {{ if .locked -}}
  value: "true"
  {{- else -}}
  value: "false"
  {{- end }}
- name: RUNNER_TAG_LIST
  value: {{ default "" .tags | quote }}
{{- if .outputLimit }}
- name: RUNNER_OUTPUT_LIMIT
  value: {{ .outputLimit | quote }}
{{- end}}
{{- if eq (default "kubernetes" .executor) "kubernetes" }}
- name: KUBERNETES_IMAGE
  value: {{ .image | quote }}
{{ if .privileged }}
- name: KUBERNETES_PRIVILEGED
  value: "true"
{{ end }}
- name: KUBERNETES_NAMESPACE
  value: {{ default $.Release.Namespace | quote }}
{{- if .pollTimeout}}
- name: KUBERNETES_POLL_TIMEOUT
  value: {{ .pollTimeout | quote }}
{{- end }}
- name: KUBERNETES_CPU_LIMIT
  value: {{ default "" .builds.cpuLimit | quote }}
- name: KUBERNETES_CPU_LIMIT_OVERWRITE_MAX_ALLOWED
  value: {{ default "" .builds.cpuLimitOverwriteMaxAllowed | quote }}
- name: KUBERNETES_MEMORY_LIMIT
  value: {{ default "" .builds.memoryLimit | quote }}
- name: KUBERNETES_MEMORY_LIMIT_OVERWRITE_MAX_ALLOWED
  value: {{ default "" .builds.memoryLimitOverwriteMaxAllowed | quote }}
- name: KUBERNETES_CPU_REQUEST
  value: {{ default "" .builds.cpuRequests | quote }}
- name: KUBERNETES_CPU_REQUEST_OVERWRITE_MAX_ALLOWED
  value: {{ default "" .builds.cpuRequestsOverwriteMaxAllowed | quote }}
- name: KUBERNETES_MEMORY_REQUEST
  value: {{ default "" .builds.memoryRequests| quote }}
- name: KUBERNETES_MEMORY_REQUEST_OVERWRITE_MAX_ALLOWED
  value: {{ default "" .builds.memoryRequestsOverwriteMaxAllowed | quote }}
- name: KUBERNETES_SERVICE_ACCOUNT
  value: {{ include "gitlab-runner.fullname" (list $ . $name) }}
- name: KUBERNETES_SERVICE_CPU_LIMIT
  value: {{ default "" .services.cpuLimit | quote }}
- name: KUBERNETES_SERVICE_MEMORY_LIMIT
  value: {{ default "" .services.memoryLimit | quote }}
- name: KUBERNETES_SERVICE_CPU_REQUEST
  value: {{ default "" .services.cpuRequests | quote }}
- name: KUBERNETES_SERVICE_MEMORY_REQUEST
  value: {{ default "" .services.memoryRequests | quote }}
- name: KUBERNETES_HELPER_CPU_LIMIT
  value: {{ default "" .helpers.cpuLimit | quote }}
- name: KUBERNETES_HELPER_MEMORY_LIMIT
  value: {{ default "" .helpers.memoryLimit | quote }}
- name: KUBERNETES_HELPER_CPU_REQUEST
  value: {{ default "" .helpers.cpuRequests | quote }}
- name: KUBERNETES_HELPER_MEMORY_REQUEST
  value: {{ default "" .helpers.memoryRequests | quote }}
- name: KUBERNETES_HELPER_IMAGE
  value: {{ default "" .helpers.image | quote }}
- name: KUBERNETES_PULL_POLICY
  value: {{ default "" $.Values.global.imagePullPolicy | quote }}
{{- end -}}
{{- end -}}
{{- end -}}