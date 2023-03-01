{{/*
Default otlp agent image (jaeger)
*/}}
{{- define "universal-template.otlp.name" -}}
{{-   printf "jaeger-agent" }}
{{- end }}

{{/*
Default otlp agent image (jaeger)
*/}}
{{- define "universal-template.otlp.image" -}}
{{-   $repository := "" }}
{{-   $path := "jaegertracing/jaeger-agent"}}
{{-   $version := "1.32" }}
{{-   printf "%s/%s:%s" $repository $path $version}}
{{- end }}

{{/*
Default otlp agent configration (jaeger)
*/}}
{{- define "universal-template.otlp.args" -}}
- "--reporter.grpc.host-port={{ .deployment.otlp.grpcEndpoint }}:14250"
- "--processor.jaeger-binary.server-host-port=0.0.0.0:6832"
- "--processor.jaeger-compact.server-host-port=0.0.0.0:6831"
- "--processor.zipkin-compact.server-host-port=0.0.0.0:5775"
- "--processor.jaeger-binary.server-max-packet-size=65000"
- "--admin.http.host-port=0.0.0.0:14271"
- "--log-level=debug"
{{- end }}

{{/*
Default otlp agent ports (jaeger)
*/}}
{{- define "universal-template.otlp.ports" -}}
- name: jaegerthriftcom
  containerPort: 6831
  protocol: UDP
- name: jaegerthrift
  containerPort: 6832
  protocol: UDP
- name: zipkinthrift
  containerPort: 5775
  protocol: UDP
- name: serveconfigs
  containerPort: 5778
  protocol: TCP
- name: adminportf
  containerPort: 14271
  protocol: TCP
{{- end }}

{{/*
Otlp agent container template (jaeger)
*/}}
{{- define "universal-template.containers.otlp.template" -}}
- name: {{ include "universal-template.otlp.name" . }}
  {{- if .deployment.otlp.image }}
  image: {{ .deployment.otlp.image.repository }}:{{ .deployment.otlp.image.version }}
  {{- else }}
  image: {{ include "universal-template.otlp.image" . }}
  {{- end }}
  imagePullPolicy: {{ default "IfNotPresent" .deployment.otlp.imagePullPolicy }}
  {{- if .deployment.otlp.resources }}
  resources: {{ toYaml .deployment.otlp.resources | nindent 4}}
  {{- else }}
  resources: {{ include "universal-template.resources.default" . | nindent 4 }}
  {{- end }}
  args:
  {{- if .deployment.otlp.args }}
  {{-   range .deployment.otlp.args }}
  - {{ . | quote }}
  {{-   end }}
  {{- else }}
  {{-   include "universal-template.otlp.args" . | nindent 2 }}
  {{- end }}
  ports:
  {{- if .deployment.otlp.ports }}
  {{-   range .deployment.otlp.ports }}
  - name: {{ .name }}
    containerPort: {{ .port | int }}
    protocol: {{ .protocol }}
  {{-   end }}
  {{- else }}
  {{- include "universal-template.otlp.ports" . | nindent 2 }}
  {{- end }}

{{- end }}