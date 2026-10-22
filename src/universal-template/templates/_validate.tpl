{{/*
Cross-reference checks that values.schema.json cannot express. Rendered once, from validate.yaml.
*/}}
{{- define "universal-template.validate" -}}
{{- $root     := . -}}
{{- $apps     := dict -}}
{{- $services := list -}}
{{- $claims   := dict -}}
{{- range .Values.applications -}}
{{-   $_ := set $apps .name true -}}
{{- end -}}
{{- range $application := .Values.applications -}}
{{-   $fullName := include "universal-template.fullName" (list $root .name) -}}
{{-   range $index, $service := .services -}}
{{-     if and (gt $index 0) (not .name) -}}
{{-       fail (printf "applications[%s].services[%d]: only the first Service defaults to the name %q, set `name`" $application.name $index $fullName) -}}
{{-     end -}}
{{-     $name := include "universal-template.service.name" (list $fullName .) -}}
{{-     if has $name $services -}}
{{-       fail (printf "applications[%s].services: the Service name %q is used twice in the release" $application.name $name) -}}
{{-     end -}}
{{-     $services = append $services $name -}}
{{-     if and .selectApp (not (hasKey $apps (.selectApp | toString))) -}}
{{-       fail (printf "applications[%s].services: selectApp %q is not an application of this release" $application.name .selectApp) -}}
{{-     end -}}
{{-   end -}}
{{-   range .persistentVolumeClaims -}}
{{-     $claim := include "universal-template.pvc.name" (list $fullName .) -}}
{{-     if hasKey $claims $claim -}}
{{-       fail (printf "applications[%s].persistentVolumeClaims: the claim %q is used twice in the release" $application.name $claim) -}}
{{-     end -}}
{{-     $_ := set $claims $claim true -}}
{{-     if and .claimName (not (dig "keep" true .)) -}}
{{-       fail (printf "applications[%s].persistentVolumeClaims[%s]: claimName %q with keep: false would let helm delete a claim it adopted; keep it true" $application.name .name .claimName) -}}
{{-     end -}}
{{-   end -}}
{{- end -}}
{{- range $application := .Values.applications -}}
{{-   $default := "" -}}
{{-   with .services -}}
{{-     $default = include "universal-template.service.name" (list (include "universal-template.fullName" (list $root $application.name)) (first .)) -}}
{{-   end -}}
{{-   range (dig "ingress" "paths" list .) -}}
{{-     $backend := .serviceName | default $default -}}
{{-     if not (has $backend $services) -}}
{{-       fail (printf "applications[%s].ingress.paths[%s]: serviceName %q is not a Service of this release (known: %s)" $application.name .path $backend (join ", " $services)) -}}
{{-     end -}}
{{-   end -}}
{{- end -}}
{{- end }}


{{/*
Pod checks: volume names are unique and every volumeMount names a pod volume or a volumeClaimTemplate.
Usage: include "universal-template.validate.pod" (dict "application" $application "fullName" $fullName)
*/}}
{{- define "universal-template.validate.pod" -}}
{{- $app     := .application.app -}}
{{- $where   := printf "applications[%s]" .application.name -}}
{{- $volumes := list -}}
{{- range concat (include "universal-template.volumes" . | fromYamlArray) ($app.volumeClaimTemplates | default list) -}}
{{-   if has .name $volumes -}}
{{-     fail (printf "%s: the volume name %q is used twice (volume-configs and volume-secrets are reserved for configMap and secret)" $where .name) -}}
{{-   end -}}
{{-   $volumes = append $volumes .name -}}
{{- end -}}
{{- range $container := concat ($app.initContainers | default list) ($app.containers | default list) -}}
{{-   range .volumeMounts -}}
{{-     if not (has .name $volumes) -}}
{{-       fail (printf "%s: container %q mounts %q, which is not a volume of the pod (known: %s)" $where $container.name .name (join ", " $volumes)) -}}
{{-     end -}}
{{-   end -}}
{{- end -}}
{{- end }}
