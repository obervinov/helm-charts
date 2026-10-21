{{/*
Expand the name of the chart.
*/}}
{{- define "universal-template.name" -}}
{{-   .Release.Name | trunc 63 | trimSuffix "-" | lower }}
{{- end }}


{{/*
Expand the appPrefix for applications.
*/}}
{{- define "universal-template.fullName" -}}
{{-   $ := index . 0 }}
{{-   $appPrefix := index . 2 -}}
{{-   with index . 1 }}
{{-     $name := include "universal-template.name" $ -}}
{{-     if gt (len $.Values.applications) 1 }}
{{-        printf "%s-%s" $name $appPrefix }}
{{-     else }}
{{-         printf "%s" $name }}
{{-     end }}
{{-   end }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "universal-template.chart" -}}
{{-   printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Common labels
*/}}
{{- define "universal-template.labels" -}}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
app.kubernetes.io/version: "{{ replace "+" "_" .Chart.Version }}"
app: {{ .Release.Name | quote }}
version: {{ .Chart.Version | quote }}
{{- end }}


{{/*
Selector labels
*/}}
{{- define "universal-template.selectorLabels" -}}
{{-   $fullName := index . 0 -}}
appselector: {{ $fullName }}
{{- end }}


{{/*
Selector labels for prometheus operator
*/}}
{{- define "universal-template.prometheus.labels" -}}
release: "kube-prometheus-stack"
jobLabel: {{ .Release.Name | quote }}
{{- end }}


{{/*
Service Account
*/}}
{{- define "universal-template.serviceAccount" -}}
{{-   $fullName := index . 0 -}}
{{-   $serviceAccount := index . 1 -}}
{{-   if $serviceAccount.create -}}
serviceAccountName: {{ $fullName }}
{{-   else if $serviceAccount.useExistingServiceAccount -}}
serviceAccountName: {{ $serviceAccount.useExistingServiceAccount }}
{{-   else -}}
serviceAccountName: default
{{-   end -}}
{{- end }}


{{/*
Name of a Service from applications[].services[].
  name        - exact name
  nameSuffix  - <fullName>-<nameSuffix>
  (neither)   - <fullName>, allowed for the first Service of the application only
Usage: include "universal-template.service.name" (list $fullName $appName $service $index)
*/}}
{{- define "universal-template.service.name" -}}
{{-   $fullName := index . 0 -}}
{{-   $appName  := index . 1 -}}
{{-   $service  := index . 2 -}}
{{-   $index    := index . 3 -}}
{{-   if $service.name -}}
{{-     $service.name -}}
{{-   else if $service.nameSuffix -}}
{{-     printf "%s-%s" $fullName $service.nameSuffix -}}
{{-   else if eq (int $index) 0 -}}
{{-     $fullName -}}
{{-   else -}}
{{-     fail (printf "applications[%s].services[%d]: only the first Service defaults to the name %q, set `name` or `nameSuffix`" $appName (int $index) $fullName) -}}
{{-   end -}}
{{- end }}


{{/*
Names of all Services rendered by the release, as a JSON list.
*/}}
{{- define "universal-template.service.allNames" -}}
{{-   $root  := . -}}
{{-   $names := list -}}
{{-   range $application := $root.Values.applications -}}
{{-     $fullName := include "universal-template.fullName" (list $root $application $application.name) -}}
{{-     range $index, $service := $application.services -}}
{{-       $names = append $names (include "universal-template.service.name" (list $fullName $application.name $service $index)) -}}
{{-     end -}}
{{-   end -}}
{{-   toJson $names -}}
{{- end }}


{{/*
Pod selector of a Service.
  selector   - raw label map, used as is
  selectApp  - pods of another application of this release (appselector: <its fullName>)
  (neither)  - pods of the application that owns the Service
Usage: include "universal-template.service.selector" (list $ $fullName $appName $service)
*/}}
{{- define "universal-template.service.selector" -}}
{{-   $root     := index . 0 -}}
{{-   $fullName := index . 1 -}}
{{-   $appName  := index . 2 -}}
{{-   $service  := index . 3 -}}
{{-   if $service.selector -}}
{{-     toYaml $service.selector -}}
{{-   else if $service.selectApp -}}
{{-     $target := dict -}}
{{-     range $root.Values.applications -}}
{{-       if eq .name $service.selectApp -}}
{{-         $target = . -}}
{{-       end -}}
{{-     end -}}
{{-     if not $target -}}
{{-       fail (printf "applications[%s].services: selectApp %q is not an application of this release" $appName $service.selectApp) -}}
{{-     end -}}
{{-     include "universal-template.selectorLabels" (list (include "universal-template.fullName" (list $root $target $target.name))) -}}
{{-   else -}}
{{-     include "universal-template.selectorLabels" (list $fullName) -}}
{{-   end -}}
{{- end }}


{{/*
Name of a standalone PersistentVolumeClaim: exact claimName or <fullName>-<name>.
Usage: include "universal-template.pvc.name" (list $fullName $pvc)
*/}}
{{- define "universal-template.pvc.name" -}}
{{-   $fullName := index . 0 -}}
{{-   $pvc      := index . 1 -}}
{{-   if $pvc.claimName -}}
{{-     $pvc.claimName -}}
{{-   else -}}
{{-     printf "%s-%s" $fullName $pvc.name -}}
{{-   end -}}
{{- end }}


{{/*
Release-wide checks that do not belong to a single manifest:
unique Service names and unique PersistentVolumeClaim names.
*/}}
{{- define "universal-template.validate.release" -}}
{{-   $root := . -}}
{{-   $seen := dict -}}
{{-   range $name := (include "universal-template.service.allNames" $root | fromJsonArray) -}}
{{-     if hasKey $seen $name -}}
{{-       fail (printf "services: the Service name %q is rendered twice, give one of them another `name` or `nameSuffix`" $name) -}}
{{-     end -}}
{{-     $_ := set $seen $name true -}}
{{-   end -}}
{{-   $claims := dict -}}
{{-   range $application := $root.Values.applications -}}
{{-     $fullName := include "universal-template.fullName" (list $root $application $application.name) -}}
{{-     range $pvc := $application.persistentVolumeClaims -}}
{{-       $claim := include "universal-template.pvc.name" (list $fullName $pvc) -}}
{{-       if hasKey $claims $claim -}}
{{-         fail (printf "applications[%s].persistentVolumeClaims: the claim %q is rendered twice" $application.name $claim) -}}
{{-       end -}}
{{-       $_ := set $claims $claim true -}}
{{-     end -}}
{{-   end -}}
{{- end }}


{{/*
Pod-level checks: volume names are unique and every volumeMount points at a volume
(app.volumes, the chart-managed volume-configs/volume-secrets, or a volumeClaimTemplate).
Usage: include "universal-template.validate.pod" (dict "name" $name "app" $app "configMap" $configMap "secret" $secret)
*/}}
{{- define "universal-template.validate.pod" -}}
{{-   $name      := .name -}}
{{-   $app       := .app -}}
{{-   $configMap := .configMap -}}
{{-   $secret    := .secret -}}
{{-   $volumes   := dict -}}
{{-   if and $configMap $configMap.files -}}
{{-     $_ := set $volumes "volume-configs" true -}}
{{-   end -}}
{{-   if and $secret $secret.mountPath -}}
{{-     $_ := set $volumes "volume-secrets" true -}}
{{-   end -}}
{{-   range $app.volumes -}}
{{-     if hasKey $volumes .name -}}
{{-       fail (printf "applications[%s].app.volumes: the volume name %q is used twice (volume-configs and volume-secrets are reserved by configMap/secret)" $name .name) -}}
{{-     end -}}
{{-     $_ := set $volumes .name true -}}
{{-   end -}}
{{-   range $app.volumeClaimTemplates -}}
{{-     if hasKey $volumes .name -}}
{{-       fail (printf "applications[%s].app.volumeClaimTemplates: %q is also defined in app.volumes" $name .name) -}}
{{-     end -}}
{{-     $_ := set $volumes .name true -}}
{{-   end -}}
{{-   range $container := concat ($app.initContainers | default list) ($app.containers | default list) -}}
{{-     range $container.volumeMounts -}}
{{-       if not (hasKey $volumes .name) -}}
{{-         fail (printf "applications[%s]: container %q mounts %q, which is not in app.volumes or app.volumeClaimTemplates" $name $container.name .name) -}}
{{-       end -}}
{{-     end -}}
{{-   end -}}
{{- end }}


{{/*
volumeMounts of one container, keys in a fixed order (name, mountPath first, as 3.x rendered them).
Usage: include "universal-template.volumeMounts" $container.volumeMounts
*/}}
{{- define "universal-template.volumeMounts" -}}
{{-   range . }}
- name: {{ .name }}
  mountPath: {{ .mountPath }}
{{-     if hasKey . "readOnly" }}
  readOnly: {{ .readOnly }}
{{-     end }}
{{-     with .subPath }}
  subPath: {{ . }}
{{-     end }}
{{-     with .subPathExpr }}
  subPathExpr: {{ . }}
{{-     end }}
{{-     with .mountPropagation }}
  mountPropagation: {{ . }}
{{-     end }}
{{-     with .recursiveReadOnly }}
  recursiveReadOnly: {{ . }}
{{-     end }}
{{-   end }}
{{- end }}
