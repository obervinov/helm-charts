# Change Log
All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).


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
