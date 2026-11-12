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


{{/*
Port (number) of the Service `name` of this release: the port named `portName`, the number `port`,
or the first port of the Service. HTTPRoute backendRefs take a port number only, so a port name
is resolved here. Fails for a Service or port name the release does not have.
Usage: include "universal-template.service.port" (dict "root" $ "where" $where "name" $name ["port" 80] ["portName" "http"])
*/}}
{{- define "universal-template.service.port" -}}
{{- $root := .root -}}
{{- $want := .name -}}
{{- $found := list -}}
{{- $known := list -}}
{{- range $application := $root.Values.applications -}}
{{-   $fullName := include "universal-template.fullName" (dict "root" $root "name" $application.name) -}}
{{-   range .services -}}
{{-     $name := include "universal-template.service.name" (dict "fullName" $fullName "service" .) -}}
{{-     $known = append $known $name -}}
{{-     if eq $name $want -}}
{{-       $found = append $found . -}}
{{-     end -}}
{{-   end -}}
{{- end -}}
{{- if not $found -}}
{{-   fail (printf "%s: serviceName %q is not a Service of this release (known: %s)" .where $want (join ", " $known)) -}}
{{- end -}}
{{- $ports := (first $found).ports | default list -}}
{{- if .portName -}}
{{-   $number := "" -}}
{{-   range $ports -}}
{{-     if eq (.name | default "") $.portName -}}
{{-       $number = .port | toString -}}
{{-     end -}}
{{-   end -}}
{{-   if not $number -}}
{{-     fail (printf "%s: the Service %q has no port named %q" .where $want .portName) -}}
{{-   end -}}
{{-   $number -}}
{{- else if .port -}}
{{-   .port | toString -}}
{{- else if $ports -}}
{{-   (first $ports).port | toString -}}
{{- else -}}
{{-   fail (printf "%s: the Service %q has no ports" .where $want) -}}
{{- end -}}
{{- end }}


{{/*
Backend of the default HTTPRoute rule: `route.serviceName` / `.servicePortName` / `.servicePort` when
any of them is set, else the backend of the first ingress path, else the first Service of the
application on its first port - the same Service and port the Ingress of the application uses.
Usage: include "universal-template.route.defaultBackend" (dict "root" $ "application" $application)
*/}}
{{- define "universal-template.route.defaultBackend" -}}
{{- $route := .application.route -}}
{{- $source := pick $route "serviceName" "servicePort" "servicePortName" -}}
{{- if not $source -}}
{{-   $source = first (dig "ingress" "paths" list .application) | default dict -}}
{{- end -}}
{{- $where := printf "applications[%s].route" .application.name -}}
{{- $name := $source.serviceName | default (include "universal-template.ingress.defaultService" .) -}}
{{- if not $name -}}
{{-   fail (printf "%s: the application has no Service; set route.serviceName or route.rules" $where) -}}
{{- end -}}
{{- $port := include "universal-template.service.port" (dict "root" .root "where" $where "name" $name "port" $source.servicePort "portName" $source.servicePortName) -}}
{{- toYaml (dict "name" $name "port" (atoi $port)) -}}
{{- end }}


{{/*
hostnames of an HTTPRoute: `route.hostnames` when the key is set (an empty list too), else the ingress fqdn.
Usage: include "universal-template.route.hostnames" $application
*/}}
{{- define "universal-template.route.hostnames" -}}
{{- if hasKey .route "hostnames" -}}
{{-   toYaml (.route.hostnames | default list) -}}
{{- else -}}
{{-   with dig "ingress" "fqdn" "" . -}}
{{-     toYaml (list .) -}}
{{-   else -}}
{{-     toYaml list -}}
{{-   end -}}
{{- end -}}
{{- end }}
