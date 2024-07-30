{{/*
Volumes for pods template
*/}}
{{- define "universal-template.volumes.template"              -}}
{{-     $volumesData        := .                               }}
{{-     $targetType         := $volumesData.targetType         }}
{{-     $configMap          := $volumesData.configMap          }}
{{-     $secret             := $volumesData.secret             }}
{{-     $fullName           := $volumesData.fullName           }}
{{-     $persistentVolume   := $volumesData.persistentVolume   }}
{{-     $emptyDirVolume     := $volumesData.emptyDirVolume     }}
{{-     $externalSecrets    := $volumesData.externalSecrets    }}
{{-     $externalConfigMaps := $volumesData.externalConfigMaps }}

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
{{-   if $externalConfigMaps }}
{{-     range $externalConfigMaps }}
{{-       if .mountPath }}
- name: {{ .name }}
  configMap:
    name: {{ .name }}
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
{{-   if $externalSecrets }}
{{-     range $externalSecrets }}
{{-       if .mountPath }}
- name: {{ .name }}
  secret:
    secretName: {{ .name }}
{{-       end }}
{{-     end }}
{{-   end }}
{{-   if $emptyDirVolume }}
- name: {{ $emptyDirVolume.name }}
  emptyDir:
    sizeLimit: {{ $emptyDirVolume.sizeLimit }}
{{-   end }}
{{-   if $persistentVolume }}
{{-     if ne $targetType "statefulset" }} 
- name: {{ $persistentVolume.name }}
  persistentVolumeClaim:
    claimName: {{ $fullName }}-{{ $persistentVolume.name }}
{{-     end }}
{{-   end }}
{{- end }}
