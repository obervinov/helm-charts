{{/*
Containers template
*/}}
{{- define "universal-template.container.template"              -}}
{{-     $containerData      := .                                 }}
{{-     $name               := $containerData.name               }}
{{-     $app                := $containerData.app                }}
{{-     $configMap          := $containerData.configMap          }}
{{-     $secret             := $containerData.secret             }}
{{-     $persistentVolume   := $containerData.persistentVolume   }}
{{-     $emptyDirVolume     := $containerData.emptyDirVolume     }}
{{-     $image              := $app.image                        }}
{{-     $envs               := $app.envs                         }}
{{-     $resources          := $app.resources                    }}
{{-     $probes             := $app.probes                       }}
{{-     $ports              := $app.ports                        }}
{{-     $externalSecrets    := $containerData.externalSecrets    }}
{{-     $externalConfigMaps := $containerData.externalConfigMaps }}
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
  {{- if $ports }}
  ports:
  {{-   range $ports }}
    - containerPort: {{ .containerPort }}
      name: {{ .name }}
      protocol: {{ .protocol }}
  {{-   end }}
  {{- end }}
  {{- if $envs }}
  env:
  {{-   toYaml $envs | nindent 4 }}
  {{- end }}
  {{- if $resources }}
  resources: {{-   toYaml $resources | nindent 4 }}
  {{- end }}
  {{- if or $configMap $persistentVolume $emptyDirVolume }}
  volumeMounts:
  {{-   if $configMap }}
  {{-     if $configMap.mountPath }}
    - name: volume-configs
      mountPath: {{ $configMap.mountPath | lower }}
      readOnly: true
  {{-     end }}
  {{-   end }}
  {{-   if $externalConfigMaps }}
  {{-     range $externalConfigMaps }}
  {{-       if .mountPath }}
    - name: {{ .name }}
      mountPath: {{ .mountPath }}
      readOnly: true
  {{-       end }}
  {{-     end }}
  {{-   end }}
  {{-   if $secret }}
  {{-     if $secret.mountPath }}
    - name: volume-secrets
      mountPath: {{ $secret.mountPath | lower }}
      readOnly: true
  {{-     end }}
  {{-   end }}
  {{-   if $externalSecrets }}
  {{-     range $externalSecrets }}
  {{-       if .mountPath }}
    - name: {{ .name }}
      mountPath: {{ .mountPath }}
      readOnly: true
  {{-       end }}
  {{-     end }}
  {{-   end }}
  {{-   if $persistentVolume }}
    - name: {{ $persistentVolume.name }}
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