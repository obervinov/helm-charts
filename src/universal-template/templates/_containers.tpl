{{/*
Containers template
*/}}
{{- define "universal-template.container.template"              -}}
{{-     $containerData      := .                                 }}
{{-     $name               := $containerData.name               }}
{{-     $app                := $containerData.app                }}
{{-     $configMap          := $containerData.configMap          }}
{{-     $secret             := $containerData.secret             }}
{{-     $image              := $app.image                        }}
{{-     $lifecycle          := $app.lifecycle                    }}
{{-     $envs               := $app.envs                         }}
{{-     $resources          := $app.resources                    }}
{{-     $probes             := $app.probes                       }}
{{-     $ports              := $app.ports                        }}
{{-     $securityContext    := $app.securityContext              }}
{{-     $volumeMounts       := $app.volumeMounts                 }}
{{-     $mounts             := ""                                }}
{{-     if and $configMap $configMap.mountPath }}
{{-       $mounts = printf "%s\n- name: volume-configs\n  mountPath: %s\n  readOnly: true" $mounts ($configMap.mountPath | lower) }}
{{-     end }}
{{-     if and $secret $secret.mountPath }}
{{-       $mounts = printf "%s\n- name: volume-secrets\n  mountPath: %s\n  readOnly: true" $mounts ($secret.mountPath | lower) }}
{{-     end }}
{{-     if $volumeMounts }}
{{-       $mounts = printf "%s%s" $mounts (include "universal-template.volumeMounts" $volumeMounts) }}
{{-     end }}
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
  {{- if $lifecycle }}
  lifecycle:
  {{-   toYaml $lifecycle | nindent 4 }}
  {{- end }}
  {{- if $envs }} 
  env:
  {{-   toYaml $envs | nindent 4 }}
  {{- end }}
  {{- if $securityContext }}
  securityContext:
  {{-   toYaml $securityContext | nindent 4 }}
  {{- end }}
  {{- if $resources }}
  resources: {{-   toYaml $resources | nindent 4 }}
  {{- end }}
  {{- if $mounts }}
  volumeMounts:
  {{-   $mounts | trimPrefix "\n" | nindent 4 }}
  {{- end }}
  {{- if $probes }}
  {{-   with $probes.livenessProbe }}
  livenessProbe:
  {{-     toYaml . | nindent 4 }}
  {{-   end }}
  {{-   with $probes.readinessProbe }}
  readinessProbe:
  {{-     toYaml . | nindent 4 }}
  {{-   end }}
  {{-   with $probes.startupProbe }}
  startupProbe:
  {{-     toYaml . | nindent 4 }}
  {{-   end }}
  {{- end }}

{{- end }}
