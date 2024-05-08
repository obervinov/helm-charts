{{/*
Volumes for pods template
*/}}
{{- define "universal-template.volumes.template"           -}}
{{-     $volumesData       := .                             }}
{{-     $targetType        := $volumesData.targetType       }}
{{-     $configMap         := $volumesData.configMap        }}
{{-     $fullName          := $volumesData.fullName         }}
{{-     $persistentVolume  := $volumesData.persistentVolume }}
{{-     $emptyDirVolume    := $volumesData.emptyDirVolume   }}
{{-   if $configMap }}
- name: volume-configs
  configMap:
    name: {{ $fullName }}
    items:
{{-     range $configMap.files }}
      - key: {{ .name | lower }}
        path: {{ .name | lower }}
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
