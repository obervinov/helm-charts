{{/*
Volumes for pods template
  - volume-configs: the ConfigMap rendered from configMap.files
  - volume-secrets: the Secret rendered from secret.data (only when secret.mountPath is set)
  - app.volumes:    raw Kubernetes volume sources, rendered as is
*/}}
{{- define "universal-template.volumes.template"              -}}
{{-     $volumesData        := .                               }}
{{-     $configMap          := $volumesData.configMap          }}
{{-     $secret             := $volumesData.secret             }}
{{-     $fullName           := $volumesData.fullName           }}
{{-     $volumes            := $volumesData.volumes            }}

{{-   if $configMap }}
{{-     if $configMap.files }}
- name: volume-configs
  configMap:
    name: {{ $fullName }}
    items:
{{-       range $configMap.files }}
      - key: {{ .name | lower }}
        path: {{ .name | lower }}
{{-       end }}
{{-     end }}
{{-   end }}
{{-   if $secret }}
{{-     if $secret.mountPath }}
- name: volume-secrets
  secret:
    secretName: {{ $fullName }}
{{-     end }}
{{-   end }}
{{-   if $volumes }}
{{      toYaml $volumes }}
{{-   end }}
{{- end }}
