{{/*
Initcontainers template
*/}}
{{- define "universal-template.containers.init.template" -}}
{{-   $ := index . 0 }}
{{-   $fullName := index . 2 }}
{{-   with index . 1 -}}

- name: initContainer-{{ .initContainer.name }}
  image: {{ .initContainer.image.repository }}:{{ default .deployment.initContainer.image.version }}
  imagePullPolicy: {{ .initContainer.image.imagePullPolicy }}
  {{- if .initContainer.resources }}
  resources: {{- toYaml .initContainer.resources | nindent 10 }}
  {{- else }}
  resources: {{- include "universal-template.resources.default" . | nindent 10 }}
  {{- end }}
  {{- if .initContainer.commands }}
  command:
  {{-   range .initContainer.commands }}
    - {{ . | quote }}
  {{-   end }}
  {{- end }}
  {{- if .initContainer.args }}
  args:
  {{-   range .initContainer.args }}
    - {{ . | quote }}
  {{-   end }}
  {{- end }}
  {{- if or (.initContainer.envs) (.initContainer.envsSecret) }}
  env:
  {{- end }}
  {{- if .initContainer.envs }}
  {{-   range $name, $value := .initContainer.envs }}
  - name: {{ $name | quote }}
    value: {{ $value | quote }}
  {{-   end }}
  {{- end }}
  {{- if .initContainer.envsSecret }}
  {{-   range .initContainer.envsSecret }}
  - name: {{ .name }}
    valueFrom:
      secretKeyRef:
        name: {{ $fullName }}
        key: {{ .keySecret }}
  {{-   end }}
  {{- end }}
  {{- if .initContainer.probes }}
  {{- toYaml .initContainer.probes | nindent 8 }}
  {{- end }}
  {{- if .configmap }}
  volumeMounts:
  {{-   range .configmap }}
  - name: volume-configs
    mountPath: {{ .mountPath | lower }}
  {{-    end }}
  {{-  end }}

{{-   end -}}
{{- end }}
