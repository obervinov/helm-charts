{{/*
Release name, lowercased and cut to 63 characters.
*/}}
{{- define "universal-template.name" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" | lower -}}
{{- end }}


{{/*
Helpers that take one value get it as is; helpers that take several get a dict with named keys.
*/}}


{{/*
Name of an application's objects: <release> when the release has one application,
<release>-<application name> when it has several.
Usage: include "universal-template.fullName" (dict "root" $ "name" $application.name)
*/}}
{{- define "universal-template.fullName" -}}
{{- $release := include "universal-template.name" .root -}}
{{- if gt (len .root.Values.applications) 1 -}}
{{-   printf "%s-%s" $release .name -}}
{{- else -}}
{{-   $release -}}
{{- end -}}
{{- end }}


{{/*
Selector of a Deployment/StatefulSet (spec.selector is immutable: never extend it).
Usage: include "universal-template.selectorLabels" $fullName
*/}}
{{- define "universal-template.selectorLabels" -}}
{{- dict "appselector" . | toYaml -}}
{{- end }}


{{/*
Pods of one application of this release, for Service, NetworkPolicy and monitor selectors.
Usage: include "universal-template.podSelector" (dict "root" $ "fullName" $fullName)
*/}}
{{- define "universal-template.podSelector" -}}
{{- dict "appselector" .fullName "app.kubernetes.io/instance" .root.Release.Name | toYaml -}}
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
Usage: include "universal-template.service.name" (dict "fullName" $fullName "service" $service)
*/}}
{{- define "universal-template.service.name" -}}
{{- .service.name | default .fullName -}}
{{- end }}


{{/*
Pod selector of a Service: a raw `selector`, the pods of `selectApp`, or the pods of its own application.
Usage: include "universal-template.service.selector" (dict "root" $ "fullName" $fullName "service" $service)
*/}}
{{- define "universal-template.service.selector" -}}
{{- $root := .root -}}
{{- with .service.selector -}}
{{-   toYaml . -}}
{{- else -}}
{{-   $target := .fullName -}}
{{-   with .service.selectApp -}}
{{-     $target = include "universal-template.fullName" (dict "root" $root "name" .) -}}
{{-   end -}}
{{-   include "universal-template.podSelector" (dict "root" $root "fullName" $target) -}}
{{- end -}}
{{- end }}


{{/*
Backend of an ingress path without serviceName: the first Service of the application, or "".
Usage: include "universal-template.ingress.defaultService" (dict "root" $ "application" $application)
*/}}
{{- define "universal-template.ingress.defaultService" -}}
{{- $fullName := include "universal-template.fullName" (dict "root" .root "name" .application.name) -}}
{{- with .application.services -}}
{{-   include "universal-template.service.name" (dict "fullName" $fullName "service" (first .)) -}}
{{- end -}}
{{- end }}


{{/*
Name of a standalone PersistentVolumeClaim: exact claimName or <fullName>-<name>.
Usage: include "universal-template.pvc.name" (dict "fullName" $fullName "claim" $claim)
*/}}
{{- define "universal-template.pvc.name" -}}
{{- .claim.claimName | default (printf "%s-%s" .fullName .claim.name) -}}
{{- end }}


{{/*
spec of a PersistentVolumeClaim (standalone claim or claim template).
Usage: include "universal-template.pvc.spec" $claim
*/}}
{{- define "universal-template.pvc.spec" -}}
{{- $spec := dict "accessModes" (.accessModes | default (list "ReadWriteOnce")) "resources" (dict "requests" (dict "storage" .size)) -}}
{{- toYaml (merge $spec (pick . "storageClassName" "volumeMode" "volumeName")) -}}
{{- end }}
