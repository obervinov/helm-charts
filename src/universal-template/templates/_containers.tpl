{{/*
Containers template
*/}}
{{- define "universal-template.container.template"    -}}
{{-     $containerData     := .                        }}
{{-     $name              := $containerData.name      }}
{{-     $app               := $containerData.app       }}
{{-     $configMap         := $containerData.configMap }}
{{-     $service           := $containerData.service   }}
{{-     $image             := $app.image               }}
{{-     $envs              := $app.envs                }}
{{-     $resources         := $app.resources           }}
{{-     $persistentVolume  := $app.persistentVolume    }}
{{-     $emptyDirVolume    := $app.emptyDirVolume      }}
{{-     $probes            := $app.probes              }}
- name: {{ $name }}
  image: {{ $image.repository }}:{{ $image.tag }}
  imagePullPolicy: {{ default "IfNotPresent" $image.pullPolicy }}
  {{- if $image.commands }}
  command:
  {{-   range $image.commands }}
    - {{ . | quote }}
  {{-   end }}
  {{- end }}
  {{- if $image.args }}
  args:
  {{-   range $image.args }}
    - {{ . | quote }}
  {{-   end }}
  {{- end }}
  {{- if $service }}
  ports:
  {{-   range $service.ports }}
    - containerPort: {{ .targetPort }}
      name: {{ .name }}
      protocol: {{ .protocol }}
  {{-   end }}
  {{- end }}
  {{- if $envs }}
  env:
  {{-   range $envs }}
    - name: {{ .name }}
  {{-     if .valueFrom }}
      valueFrom:
        secretKeyRef:
          name: {{ .valueFrom.secretKeyRef.name }}
          key: {{ .valueFrom.secretKeyRef.key }}
  {{-     else }}
      value: {{ .value }}
  {{-     end }}
  {{-   end }}
  {{- end }}
  {{- if $resources }}
  resources: {{-   toYaml $resources | nindent 4 }}
  {{- end }}
  {{- if or $configMap $persistentVolume $emptyDirVolume }}
  volumeMounts:
  {{-   if $configMap }}
    - name: volume-configs
      mountPath: {{ $configMap.mountPath | lower }}
      readOnly: true
  {{-   end }}
  {{-   if $persistentVolume }}
    - name: {{ $name }}-{{ $persistentVolume.name }}
      mountPath: {{ $persistentVolume.mountPath }}
  {{-   end }}
  {{-   if $emptyDirVolume }}
    - name: {{ $emptyDirVolume.name }}
      mountPath: {{ $emptyDirVolume.mountPath }}
  {{-   end }}
  {{- end }}
  {{- if $probes }}
  livenessProbe:
  {{-   toYaml $probes.livenessProbe | nindent 4 }}
  readinessProbe:
  {{-   toYaml $probes.readinessProbe | nindent 4 }}
  startupProbe:
  {{-   toYaml $probes.startupProbe | nindent 4 }}
  {{- end }}
{{- end }}