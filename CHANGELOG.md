# Change Log
All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).


## v1.3.0 - 2026-10-22
### What's Changed
**Full Changelog**: https://github.com/obervinov/helm-charts/compare/v1.2.13...v1.3.0 by @obervinov
#### 💥 Breaking Changes
* `universal-template` 4.0.1 is the release of this contract. 4.0.0 was an unreviewed pre-release build of the same branch, published by CI before review: do not use it
* `universal-template` 4.0.1: the values contract for volumes, Services and claims changes; object names and the Deployment/StatefulSet selectors do not. `app.emptyDirVolume`, `app.persistentVolume`, `app.externalSecrets`, `app.externalConfigMaps`, `configMap.mountPath`, `secret.mountPath` and the single-map `service` are removed, see "Migrating from 3.x" in the chart README
* `universal-template`: a container mounts only its own `volumeMounts`; 3.x mounted every volume, and the chart's ConfigMap/Secret, into every container, init containers included. The chart's ConfigMap and Secret are the pod volumes `volume-configs` / `volume-secrets`, mounted by name
* `universal-template`: pod templates no longer carry the chart version labels (`version`, `app.kubernetes.io/version`): pods restart once on the upgrade to 4.x and no longer on every chart release
* `universal-template`: Service and NetworkPolicy selectors add `app.kubernetes.io/instance: <release>` next to `appselector`
* `universal-template`: `app.extraAnnotations` go on the pod template for every workload type, and no longer on the StatefulSet/CronJob object
* `universal-template`: Prometheus monitors are named `<fullName>-<name>`
* `universal-template`: `values.schema.json` is hand-written and strict, so unknown keys and the removed 3.x keys fail `helm lint`; keys 3.x accepted but never applied (`app.probes`, `app.envs`, `app.resources`, `app.cronjob`) fail too
* `universal-template`: CronJob `failedJobsHistoryLimit` / `successfulJobsHistoryLimit` default to `1` instead of `0`
#### 🚀 Features
* `universal-template`: `app.volumes` (raw volume sources, any number) and per-container `volumeMounts` with `readOnly` / `subPath`
* `universal-template`: `persistentVolumeClaims` at the application level, with an exact `claimName` to adopt an existing claim and `helm.sh/resource-policy: keep` by default
* `universal-template`: `app.volumeClaimTemplates` as a list; a StatefulSet can also run on standalone claims without any claim template
* `universal-template`: `services` as a list, with explicit names, `selectApp` to select another application of the release, a raw `selector`, and `clusterIP`
* `universal-template`: `ingress.paths[].serviceName` routes to any Service of the release
* `universal-template`: `app.strategy` (Deployment), `app.updateStrategy` and `app.serviceName` (StatefulSet), `app.type: none` for an application without a workload
* `universal-template`: rendering fails with a named cause for a duplicate application, volume, Service or claim name, a mount of an undeclared volume, an unknown `selectApp` or ingress `serviceName`, `claimName` with `keep: false`, and a `secret.data` that is not a YAML map
* `universal-template`: the schema rejects `rbac.create` together with `rbac.useExistingServiceAccount`, unknown keys in monitor `endpoints`, and `app.cronJob` / `app.job` on another workload type
* `.github/workflows/pr.yaml`: keep a `values.schema.json` marked "do not regenerate" instead of overwriting it with `helm schema-gen`
#### 🐛 Bug Fixes
* `universal-template`: Job and CronJob pods carried no labels, so no Service, NetworkPolicy or PodMonitor could select them
* `universal-template`: ServiceMonitor/PodMonitor selected `appselector` built from the monitor name, rendered a null `matchLabels`, and rendered no endpoints when `kind` was omitted; `honorLabels: false` was ignored
* `universal-template`: values are rendered as data or as quoted scalars, so a newline in any value (a name, a path, an ingress host, a ServiceAccount, an image pull secret) can no longer inject extra YAML such as `hostNetwork: true`; the schema also restricts names to DNS names and hosts, paths and API versions to strings without whitespace
* `universal-template`: Job and CronJob `backoffLimit`, `ttlSecondsAfterFinished` and `activeDeadlineSeconds` of `0` were replaced by their defaults
* `universal-template`: invalid YAML in `secret.data` rendered a Secret with the key `Error` holding the parse error
* `universal-template`: the ConfigMap volume listed files without `data`, which the ConfigMap leaves out, and lowercased the file names it pointed at
* `universal-template`: two applications with the same monitor name rendered monitors with the same name
* `universal-template`: a StatefulSet always rendered a volumeClaimTemplate for `persistentVolume` and never mounted a standalone claim
* `universal-template`: rendering crashed with a nil pointer for an application with only a Service
* `universal-template`: the secret mount was dropped when it was the only chart-managed mount of a container
* `universal-template`: `values.yaml` documented `cronjob` while the template read `cronJob`; `ingress.kind` was read as `ingress.Kind`; the Job spec carried `backoffLimit` twice; NOTES printed an empty ingress host; several Ingresses in one release ran together in one document
* `universal-template`: probes render only the probes that are set instead of `null` for the missing ones


## v1.2.13 - 2026-09-18
### What's Changed
#### 📚 Documentation
* `README.md`: repoint the three header icons at `obervinov/_templates` — the `obervinov/content` repository they came from no longer exists, so all three rendered broken — add the missing `gateway-api-crds` chart to the table, and demote the three `#` headings inside the install section to `###`.
* `README.md`: replace the hand-maintained GitHub Actions Templates table with a badge that reads the pinned version out of `.github/workflows/pr.yaml` — the table went stale on every template bump because nothing kept it in sync.


## v1.2.12 - 2026-09-17
### What's Changed
#### 🐛 Bug Fixes
* `.github/workflows`: move the reusable workflows to `obervinov/_templates@v4.0.0`. Node 20 is removed from the Actions runner on 2026-09-23, and the pinned templates still called `actions/create-release` (`runs.using: node12`, archived) along with a set of `node20` actions — releases and checks in this repository would stop running.


## v1.2.11 - 2026-06-09
### What's Changed
**Full Changelog**: https://github.com/obervinov/helm-charts/compare/v1.2.10...v1.2.11 by @obervinov in https://github.com/obervinov/helm-charts/pull/89
#### 🐛 Bug Fixes
* fix PVC name mismatch with `claimName` in the `universal-template` chart — apps using `app.persistentVolume` (deployment/cronjob/job) had pods stuck Pending on a non-existent PVC


## v1.2.10 - 2025-12-25
### What's Changed
**Full Changelog**: https://github.com/obervinov/helm-charts/compare/v1.2.9...v1.2.10 by @obervinov in https://github.com/obervinov/helm-charts/pull/85
#### 🐛 Bug Fixes
* fix the `pullSecrets` specification in the `universal-template` chart
#### 🚀 Features
* update dependencies to latest version


## v1.2.9 - 2025-07-20
### What's Changed
**Full Changelog**: https://github.com/obervinov/helm-charts/compare/v1.2.8...v1.2.9 by @obervinov in https://github.com/obervinov/helm-charts/pull/79
#### 🐛 Bug Fixes
* fix the NetworkPolicy manifest in the `universal-template` chart
#### 🚀 Features
* [Feature request: Universal-Template chart: support for Attach Handler Lifecycle Event](https://github.com/obervinov/helm-charts/issues/79)
* update dependencies to latest version

## v1.2.8 - 2025-05-26
### What's Changed
**Full Changelog**: https://github.com/obervinov/helm-charts/compare/v1.2.7...v1.2.8 by @obervinov in https://github.com/obervinov/helm-charts/pull/72
#### 🐛 Bug Fixes
* [Helm chart bug: universal-template: extra annotations and labels should be propagated in all manifests generated by the chart](https://github.com/obervinov/helm-charts/issues/75)
#### 🚀 Features
* [Feature request: add support NetworkPolicy manifest (universal-template chart)](https://github.com/obervinov/helm-charts/issues/76)
* [Feature request: add support for specifying the service port by name in Ingress (universal-template chart)](https://github.com/obervinov/helm-charts/issues/74)
* bump workflow versions to `v2.1.1`


## v1.2.7 - 2025-01-13
### What's Changed
**Full Changelog**: https://github.com/obervinov/helm-charts/compare/v1.2.6...v1.2.7 by @obervinov in https://github.com/obervinov/helm-charts/pull/71
#### 🐛 Bug Fixes
* bugfixes in `terraform-operator-crds` chart


## v1.2.6 - 2025-01-13
### What's Changed
**Full Changelog**: https://github.com/obervinov/helm-charts/compare/v1.2.5...v1.2.6 by @obervinov in https://github.com/obervinov/helm-charts/pull/70
#### 🚀 Features
* bump workflow versions
* [Feature request: Terraform-operator-crds: add the ability to set, within a specific workspace or globally, the execution mode of `remote`](https://github.com/obervinov/helm-charts/issues/43)


## v1.2.5 - 2024-12-17
### What's Changed
**Full Changelog**: https://github.com/obervinov/helm-charts/compare/v1.2.4...v1.2.5 by @obervinov in https://github.com/obervinov/helm-charts/pull/68
#### 🚀 Features
* bump workflow versions to `v2.0.2`
#### 🐛 Bug Fixes
* replace image repository for `kube-rbac-proxy` in the `wireguard-operator` chart


## v1.2.4 - 2024-09-30
### What's Changed
**Full Changelog**: https://github.com/obervinov/helm-charts/compare/v1.2.3...v1.2.4 by @obervinov in https://github.com/obervinov/helm-charts/pull/64
#### 🚀 Features
* add support `serviceAnnotations` for the `wireguard-operator-crds` chart


## v1.2.3 - 2024-09-28
### What's Changed
**Full Changelog**: https://github.com/obervinov/helm-charts/compare/v1.2.2...v1.2.3 by @obervinov in https://github.com/obervinov/helm-charts/pull/63
#### 🐛 Bug Fixes
* fix the outdated crd for the `wireguard-operator` chart


## v1.2.2 - 2024-09-28
### What's Changed
**Full Changelog**: https://github.com/obervinov/helm-charts/compare/v1.2.1...v1.2.2 by @obervinov in https://github.com/obervinov/helm-charts/pull/62
#### 🐛 Bug Fixes
* [Helm chart bug: Wireguard-operator: The names of the generated manifests are too long](https://github.com/obervinov/helm-charts/issues/61)
* fix the outdated source of the `wireguard-operator` crds


## v1.2.1 - 2024-09-27
### What's Changed
**Full Changelog**: https://github.com/obervinov/helm-charts/compare/v1.2.0...v1.2.1 by @obervinov in https://github.com/obervinov/helm-charts/pull/60
#### 🐛 Bug Fixes
* [Helm chart bug: Wireguard-operator: bugs list](https://github.com/obervinov/helm-charts/issues/59)


## v1.2.0 - 2024-09-26
### What's Changed
**Full Changelog**: https://github.com/obervinov/helm-charts/compare/v1.1.3...v1.2.0 by @obervinov in https://github.com/obervinov/helm-charts/pull/58
#### 🐛 Bug Fixes
* Fix  the contact information of the contributors in all `Chart.yaml` files.
#### 🚀 Features
* Add new helm chart `wireguard-operator`
* Add new helm chart `wireguard-operator-crds`
* Add functionality to inject CRDs into charts


## v1.1.3 - 2024-09-24
### What's Changed
**Full Changelog**: https://github.com/obervinov/helm-charts/compare/v1.1.2...v1.1.3 by @obervinov in https://github.com/obervinov/helm-charts/pull/57
#### 🐛 Bug Fixes
* [Helm chart bug: Universal-template: Fix invalid `accessModes` list structure for `PersistentVolumeClaim`](https://github.com/obervinov/helm-charts/issues/56)
#### 🚀 Features
* [Feature request: Add predefined NodePort support to template services in Universal-template chart](https://github.com/obervinov/helm-charts/issues/55)
* Bump workflow versions to `v1.2.9`


## v1.1.2 - 2024-08-05
### What's Changed
**Full Changelog**: https://github.com/obervinov/helm-charts/compare/v1.1.1...v1.1.2 by @obervinov in https://github.com/obervinov/helm-charts/pull/54
#### 🐛 Bug Fixes
* Error correction in `Universal-template` chart: `emptyDir` volume is not mounted in the container
#### 🚀 Features
* [Feature request: Add to support `securityContext` for containers in Unisersal-template helm chart](https://github.com/obervinov/helm-charts/issues/53)


## v1.1.1 - 2024-07-30
### What's Changed
**Full Changelog**: https://github.com/obervinov/helm-charts/compare/v1.1.0...v1.1.1 by @obervinov in https://github.com/obervinov/helm-charts/pull/52
#### 🐛 Bug Fixes
* [Helm chart bug: Universal-template: duplicate port definition](https://github.com/obervinov/helm-charts/issues/51)


## v1.1.0 - 2024-07-30
### What's Changed
**Full Changelog**: https://github.com/obervinov/helm-charts/compare/v1.0.6...v1.1.0 by @obervinov in https://github.com/obervinov/helm-charts/pull/50
#### 💥 Breaking Changes
* Change the structure of the `values.yaml` file in the `universal-template` chart. The old version of the file is not compatible with the new release!
#### 🚀 Features
* Bump workflow versions to `v1.2.6`
* [Feature request: Universal-template: Add support for `secret` with token from `service account`](https://github.com/obervinov/helm-charts/issues/45)
* [Feature request: Add support for multiple containers and init containers to the Universal-template helm chart](https://github.com/obervinov/helm-charts/issues/48)
* [Feature request: Expand the possibilities of working with the secret in the universal-template chart](https://github.com/obervinov/helm-charts/issues/47)
* [Feature request: Expand the possibility of RBAC in helm chart Universal-template](https://github.com/obervinov/helm-charts/issues/44)
#### 🐛 Bug Fixes
* [Helm chart bug: Universal-template: Error if environment variable contains `fieldRef` in `valueForm`](https://github.com/obervinov/helm-charts/issues/46)


## v1.0.6 - 2024-05-09
### What's Changed
**Full Changelog**: https://github.com/obervinov/helm-charts/compare/v1.0.5...v1.0.6 by @obervinov in https://github.com/obervinov/helm-charts/pull/42
#### 🚀 Features
* [Feature request: Universal-template chart: add support init containers for `statefulsets` and `deployments`](https://github.com/obervinov/helm-charts/issues/41)
* Split monolithic templates in universal-template chart into separate `_containers.tpl` and `_volumes.tpl` files for modularity and readability


## v1.0.5 - 2024-04-28
### What's Changed
**Full Changelog**: https://github.com/obervinov/helm-charts/compare/v1.0.4...v1.0.5 by @obervinov in https://github.com/obervinov/helm-charts/pull/40
#### 🚀 Features
* Add additional tasks to the GitHub actions workflow
* Bump workflow version to v1.2.0
#### 🐛 Bug Fixes
* [Add support OCI registry for helm-charts](https://github.com/obervinov/helm-charts/issues/21)
* [Universal-template: miss configuration between `volumeMounts` name and `persistentVolume` name](https://github.com/obervinov/helm-charts/issues/39)


## v1.0.4 - 2024-04-16
### What's Changed
**Full Changelog**: https://github.com/obervinov/helm-charts/compare/v1.0.3...v1.0.4 by @obervinov in https://github.com/obervinov/helm-charts/pull/37
#### 🚀 Features
* Add additional tasks to the GitHub actions workflow
#### 🐛 Bug Fixes
* [Universal-template: add emptyDir support for volumes](https://github.com/obervinov/helm-charts/issues/33)
* [Universal-template: quotation mark escaping schedule](https://github.com/obervinov/helm-charts/issues/34)
* [Universal-template: `affinity` and `nodeSelector` not provisioning in `cronJobs` and `Jobs`](https://github.com/obervinov/helm-charts/issues/35)
* [Universal-template: `ConfigMap` not working](https://github.com/obervinov/helm-charts/issues/36)


## v1.0.3 - 2024-04-08
### What's Changed
**Full Changelog**: https://github.com/obervinov/helm-charts/compare/v1.0.2...v1.0.3 by @obervinov in https://github.com/obervinov/helm-charts/pull/32
#### 🐛 Bug Fixes
* [Universal-template: fix bugs in 2.0.0](https://github.com/obervinov/helm-charts/issues/31)


## v1.0.2 - 2024-04-07
### What's Changed
**Full Changelog**: https://github.com/obervinov/helm-charts/compare/v1.0.1...v1.0.2 by @obervinov in https://github.com/obervinov/helm-charts/pull/30
#### 🚀 Features
* [Universal-template: add `StatefulSet` support for applications](https://github.com/obervinov/helm-charts/issues/29)
* Global refactoring of Helm-chart `universal-template`: simplified structure, removed all obsolete and redundant designs
* [Gateway-api-crds: add new helm chart](https://github.com/obervinov/helm-charts/issues/19)
#### 📚 Documentation
* Universal-template: documentation update
#### 💥 Breaking Changes
* Global refactoring of Helm-chart `universal-template`: the structure of the chart and values-file has been changed globally, old versions of values-file are completely incompatible with the new release!
#### 🐛 Bug Fixes
* [Terraform-operator-crds: applyMethod behavior is wrong](https://github.com/obervinov/helm-charts/issues/27)
* [The release creation workflow started twice](https://github.com/obervinov/helm-charts/issues/26)
* [Renovate disabled to update helm dependencies](https://github.com/obervinov/helm-charts/issues/23)


## v1.0.1 - 2024-01-19
### What's Changed
**Full Changelog**: https://github.com/obervinov/helm-charts/compare/v1.0.0...v1.0.1 by @obervinov in https://github.com/obervinov/helm-charts/pull/25
#### 🐛 Bug Fixes
* [Correct errors in the workflows of this repository](https://github.com/obervinov/helm-charts/issues/24)
* [Action Required: Fix Renovate Configuration](https://github.com/obervinov/helm-charts/issues/23)


## v1.0.0 - 2024-01-19
### What's Changed
**Full Changelog**: https://github.com/obervinov/helm-charts/compare/...v1.0.0 by @obervinov in https://github.com/obervinov/helm-charts/pull/20
#### 🐛 Bug Fixes
* [Universal-template: fix typos and errors](https://github.com/obervinov/helm-charts/issues/15)
#### 📚 Documentation
* [Arrange the repository in accordance with all the rules](https://github.com/obervinov/helm-charts/issues/12)
* [Universe-template: make more detailed documentation about the supported resource types](https://github.com/obervinov/helm-charts/issues/11)
#### 🚀 Features
* [Automate the assembly of helm charts via GH Actions](https://github.com/obervinov/helm-charts/issues/14)
* [Decompose the chart sources and already assembled packages into different directories](https://github.com/obervinov/helm-charts/issues/13)
* [Terraform-operator-crds: add new chart](https://github.com/obervinov/helm-charts/issues/10)
* [Universal-template: add persistent volume support](https://github.com/obervinov/helm-charts/issues/16)
* [Universal-template: add affinity, tolerations and nodeSelector support](https://github.com/obervinov/helm-charts/issues/17)
* [Try to configure Dependabot for helm packages](https://github.com/obervinov/helm-charts/issues/18)
* [Universal-template: Add extraLables in deployment](https://github.com/obervinov/helm-charts/issues/22)
