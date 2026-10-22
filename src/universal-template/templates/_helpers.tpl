{{/*
Release name, lowercased and cut to 63 characters.
*/}}
{{- define "universal-template.name" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" | lower -}}
{{- end }}


{{/*
Name of an application's objects: <release> when the release has one application,
<release>-<application name> when it has several.
Usage: include "universal-template.fullName" (list $ $applicationName)
*/}}
{{- define "universal-template.fullName" -}}
{{- $root := index . 0 -}}
{{- $name := include "universal-template.name" $root -}}
{{- if gt (len $root.Values.applications) 1 -}}
{{-   printf "%s-%s" $name (index . 1) -}}
{{- else -}}
{{-   $name -}}
{{- end -}}
{{- end }}


{{/*
Selector of a Deployment/StatefulSet (spec.selector is immutable: never extend it).
Usage: include "universal-template.selectorLabels" (list $fullName)
*/}}
{{- define "universal-template.selectorLabels" -}}
{{- dict "appselector" (index . 0) | toYaml -}}
{{- end }}


{{/*
Pods of one application of this release, for Service, NetworkPolicy and monitor selectors.
Usage: include "universal-template.podSelector" (list $ $fullName)
*/}}
{{- define "universal-template.podSelector" -}}
{{- dict "appselector" (index . 1) "app.kubernetes.io/instance" (index . 0).Release.Name | toYaml -}}
{{- end }}


{{/*
labels (and annotations) of an object or a pod template.
Chart labels win over extra labels with the same key; pod templates carry no chart version,
so a chart upgrade alone does not restart pods.
Usage: include "universal-template.metadata" (dict "root" $ "fullName" $fullName ["pod" true] ["labels" $extra] ["annotations" $extra])
*/}}
{{- define "universal-template.metadata" -}}
{{- $root := .root -}}
{{- $labels := dict "app.kubernetes.io/managed-by" $root.Release.Service "app.kubernetes.io/instance" $root.Release.Name "app" $root.Release.Name "appselector" .fullName -}}
{{- if not .pod -}}
{{-   $_ := set $labels "app.kubernetes.io/version" (replace "+" "_" $root.Chart.Version) -}}
{{-   $_ := set $labels "version" $root.Chart.Version -}}
{{- end -}}
labels: {{- merge $labels (.labels | default dict) | toYaml | nindent 2 }}
{{- with .annotations }}
annotations: {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}


{{/*
Name of the n-th Service of an application: `name`, or <fullName> for the first one
(_validate.tpl rejects a later Service without a name).
Usage: include "universal-template.service.name" (list $fullName $service)
*/}}
{{- define "universal-template.service.name" -}}
{{- (index . 1).name | default (index . 0) -}}
{{- end }}


{{/*
Pod selector of a Service: a raw `selector`, the pods of `selectApp`, or the pods of its own application.
Usage: include "universal-template.service.selector" (list $ $fullName $service)
*/}}
{{- define "universal-template.service.selector" -}}
{{- $root    := index . 0 -}}
{{- $service := index . 2 -}}
{{- with $service.selector -}}
{{-   toYaml . -}}
{{- else -}}
{{-   $target := index . 1 -}}
{{-   with $service.selectApp -}}
{{-     $target = include "universal-template.fullName" (list $root .) -}}
{{-   end -}}
{{-   include "universal-template.podSelector" (list $root $target) -}}
{{- end -}}
{{- end }}


{{/*
Name of a standalone PersistentVolumeClaim: exact claimName or <fullName>-<name>.
Usage: include "universal-template.pvc.name" (list $fullName $pvc)
*/}}
{{- define "universal-template.pvc.name" -}}
{{- (index . 1).claimName | default (printf "%s-%s" (index . 0) (index . 1).name) -}}
{{- end }}


{{/*
spec of a PersistentVolumeClaim (standalone claim or claim template).
Usage: include "universal-template.pvc.spec" $claim
*/}}
{{- define "universal-template.pvc.spec" -}}
{{- $spec := dict "accessModes" (.accessModes | default (list "ReadWriteOnce")) "resources" (dict "requests" (dict "storage" .size)) -}}
{{- toYaml (merge $spec (pick . "storageClassName" "volumeMode" "volumeName")) -}}
{{- end }}
