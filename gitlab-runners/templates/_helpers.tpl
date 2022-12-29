{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "gitlab-runner.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "gitlab-runner.fullname" -}}
{{- $ := index . 0 }}
{{- $projectPrefix := index . 2 -}}
{{- with index . 1 }}
    {{- $name := include "gitlab-runner.name" $ -}}
    {{- printf "%s-%s" $name $projectPrefix | trunc 63 | trimSuffix "-"}}
{{- end }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "gitlab-runner.chart" -}}
{{-   printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Template for outputing the gitlabUrl
*/}}
{{- define "gitlab-runner.gitlabUrl" -}}
{{- .Values.global.gitlabUrl | quote -}}
{{- end -}}

{{/*
Unregister runners on pod stop
*/}}
{{- define "gitlab-runner.unregisterRunners" -}}
{{- $ := index . 0 -}}
{{- with index . 1 -}}
{{- if .unregisterRunners -}}
lifecycle:
  preStop:
    exec:
      command: ["/entrypoint", "unregister", "--all-runners"]
{{- end -}}
{{- end -}}
{{- end -}}
