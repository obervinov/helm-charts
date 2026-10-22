# Universal Helm Chart for Kubernetes Applications

One chart for simple releases: Deployments, StatefulSets, Jobs and CronJobs with their Services, PersistentVolumeClaims, Ingress, ConfigMap, Secret, RBAC, NetworkPolicy and Prometheus monitors, all described in `values.yaml`.

Version 4.0.1 changes the values contract (volumes, services, claims). The rendered objects keep their names and the Deployment/StatefulSet selectors, so a module translated from 3.x upgrades in place; pods restart once because their labels change. See [Migrating from 3.x](#migrating-from-3x). Do not use 4.0.0: it is an unreviewed pre-release build of the same work.

## Table of Contents

- [Installation](#installation)
- [Naming](#naming)
- [Configuration](#configuration)
  - [Applications](#applications)
  - [Containers](#containers)
  - [Volumes and mounts](#volumes-and-mounts)
  - [PersistentVolumeClaims](#persistentvolumeclaims)
  - [Services](#services)
  - [Ingress](#ingress)
  - [ConfigMap](#configmap)
  - [Secret](#secret)
  - [RBAC](#rbac)
  - [Monitoring](#monitoring)
- [Examples](#examples)
- [Migrating from 3.x](#migrating-from-3x)
- [Usage example for Gitlab-CI](#usage-example-for-gitlab-ci)

## Installation

```bash
helm repo add obervinov https://obervinov.github.io/helm-charts
helm upgrade --install my-app obervinov/universal-template -f values.yaml
# or from the OCI registry
helm upgrade --install my-app oci://ghcr.io/obervinov/helm-charts/universal-template --version 4.0.1 -f values.yaml
```

`values.schema.json` rejects unknown keys, so `helm lint -f values.yaml` catches typos and 3.x keys before anything is applied.

## Naming

- `<fullName>` is the release name when the release has one application, and `<release>-<application name>` when it has several.
- Every workload, ConfigMap, Secret, ServiceAccount and Ingress is named `<fullName>`; a Prometheus monitor is named `<fullName>-<monitor name>`.
- Every object carries `app.kubernetes.io/managed-by`, `app.kubernetes.io/instance: <release>`, `app: <release>`, `appselector: <fullName>`, and the chart version as `app.kubernetes.io/version` and `version`. Pod templates carry the same labels without the chart version, so a chart upgrade alone does not restart pods. These labels win over `extraLabels` with the same key.
- Deployment/StatefulSet selectors are `appselector: <fullName>`. Services, NetworkPolicies and monitors select `appselector: <fullName>` plus `app.kubernetes.io/instance: <release>`, so two releases whose names happen to join into the same `<fullName>` do not select each other's pods.

## Configuration

`values.yaml` is the full commented reference. The tables list each key; `[]` marks a list.

### Applications

| Parameter | Description | Default |
|-----------|-------------|---------|
| `applications[]` | List of applications | `[]` |
| `applications[].name` | Name of the application (required, lowercase DNS label) | |
| `applications[].app.type` | `deployment`, `statefulset`, `job`, `cronjob` or `none` (no workload: only the Services, claims, ingress, configMap and secret of the application are rendered) | |
| `applications[].app.replicas` | Number of replicas | `1` |
| `applications[].app.extraLabels` | Labels added to the workload, its pods and its NetworkPolicy | `{}` |
| `applications[].app.extraAnnotations` | Annotations added to the pod template, for every workload type (not to the workload object) | `{}` |
| `applications[].app.imagePullSecrets` | Secret names, rendered as `imagePullSecrets: [{name: ...}]` | `[]` |
| `applications[].app.containers[]` | Containers, see [Containers](#containers) | |
| `applications[].app.initContainers[]` | Init containers, same keys as containers | `[]` |
| `applications[].app.volumes[]` | Pod volumes, raw Kubernetes volume sources, see [Volumes and mounts](#volumes-and-mounts) | `[]` |
| `applications[].app.volumeClaimTemplates[]` | StatefulSet only: claim templates (`name`, `size`, `storageClassName`, `accessModes`, `volumeMode`) | `[]` |
| `applications[].app.strategy` | Deployment only: `spec.strategy` as is, e.g. `{type: Recreate}` | |
| `applications[].app.updateStrategy` | StatefulSet only: `spec.updateStrategy` as is | |
| `applications[].app.serviceName` | StatefulSet only: governing Service name | `<fullName>` |
| `applications[].app.affinity` | Pod affinity | `{}` |
| `applications[].app.nodeSelector` | Pod node selector | `{}` |
| `applications[].app.tolerations` | Pod tolerations | `[]` |
| `applications[].app.networkPolicy` | `policyTypes`, `ingress`, `egress` of a NetworkPolicy selecting the pods | |
| `applications[].app.cronJob` | CronJob only (required there): `schedule` (required), `failedJobsHistoryLimit` (default `1`), `successfulJobsHistoryLimit` (default `1`), `concurrencyPolicy` (default `Forbid`), `restartPolicy` (default `Never`), `ttlSecondsAfterFinished` (default `300`), `activeDeadlineSeconds` (default `300`), `backoffLimit` (default `3`), `parallelism`, `completions` | |
| `applications[].app.job` | Job only: `restartPolicy` (default `Never`), `ttlSecondsAfterFinished` (default `300`), `activeDeadlineSeconds` (default `600`), `backoffLimit` (default `3`), `parallelism`, `completions` | |

### Containers

| Parameter | Description | Default |
|-----------|-------------|---------|
| `containers[].name` | Container name (required) | |
| `containers[].image.repository` / `.tag` | Image (required) | |
| `containers[].image.pullPolicy` | Pull policy | `IfNotPresent` |
| `containers[].image.commands` / `.args` | `command` / `args` | `[]` |
| `containers[].envs[]` | `env` as is (`value`, `valueFrom`) | `[]` |
| `containers[].ports[]` | `name`, `containerPort`, `protocol` | `[]` |
| `containers[].resources` | Requests and limits | |
| `containers[].securityContext` | Container security context | |
| `containers[].lifecycle` | `postStart` / `preStop` hooks | |
| `containers[].probes` | `livenessProbe`, `readinessProbe`, `startupProbe`; only the ones set are rendered | |
| `containers[].volumeMounts[]` | Mounts of this container only: `name`, `mountPath` (required), `readOnly`, `subPath`, `subPathExpr`, `mountPropagation`, `recursiveReadOnly`. `name` is a volume from `app.volumes`, `app.volumeClaimTemplates`, `volume-configs` or `volume-secrets` | `[]` |

### Volumes and mounts

`app.volumes` is the pod's volume list, written as Kubernetes volume sources and rendered as is: `emptyDir`, `persistentVolumeClaim`, `secret` (with `items`), `configMap`, `projected`, `hostPath`, any number of each. Each container mounts only what its own `volumeMounts` list names, init containers included.

The chart adds two volumes of its own, only when it renders the object behind them: `volume-configs` (the ConfigMap `<fullName>`, when `configMap.files` has a file with `data`) and `volume-secrets` (the Secret `<fullName>`, when `secret.data` is set). Their names are reserved. Nothing is mounted automatically: a container that needs them lists them in its `volumeMounts`. Rendering fails when a volume name is used twice or a mount names a volume that does not exist.

```yaml
app:
  volumes:
    - name: data
      persistentVolumeClaim:
        claimName: my-app-data
    - name: host-keys
      secret:
        secretName: my-app-keys
        items:
          - key: ssh_host_ed25519_key
            path: ssh_host_ed25519_key
  containers:
    - name: server
      volumeMounts:
        - name: data
          mountPath: /data
    - name: sidecar
      volumeMounts:
        - name: data
          mountPath: /export
          readOnly: true
        - name: host-keys
          mountPath: /host-keys
        - name: volume-configs      # the chart's ConfigMap, this container only
          mountPath: /etc/sidecar
          readOnly: true
configMap:
  files:
    - name: sidecar.conf
      data: "..."                   # usually --set-file
```

A StatefulSet either lists `app.volumeClaimTemplates` (claims named `<name>-<fullName>-<ordinal>`, created by the StatefulSet controller) or mounts standalone claims through `app.volumes`. A StatefulSet without `volumeClaimTemplates` gets none.

### PersistentVolumeClaims

`applications[].persistentVolumeClaims[]` renders standalone claims, for any workload type (also `none`).

| Parameter | Description | Default |
|-----------|-------------|---------|
| `name` | Logical name (required) | |
| `claimName` | Exact claim name, e.g. to adopt an existing claim (see below) | `<fullName>-<name>` |
| `size` | Requested storage (required) | |
| `storageClassName` | Storage class | cluster default |
| `accessModes` | Access modes | `[ReadWriteOnce]` |
| `volumeMode` | `Filesystem` or `Block` | |
| `volumeName` | Bind to this PersistentVolume | |
| `keep` | Adds `helm.sh/resource-policy: keep`: the claim survives `helm uninstall` and a rename of the release | `true` |
| `annotations` / `labels` | Extra metadata | `{}` |

Adopting an existing claim with `claimName`: Helm only takes over an object that carries its ownership metadata (label `app.kubernetes.io/managed-by: Helm`, annotations `meta.helm.sh/release-name` and `meta.helm.sh/release-namespace`), or with `helm upgrade --install --take-ownership`. An adopted claim must keep `keep: true`: with `keep: false` a later `helm uninstall` or the removal of the entry would delete a claim, and its data, that this release did not create. Rendering fails for `claimName` together with `keep: false`.

Claims from `volumeClaimTemplates` cannot carry the keep annotation. Helm does not manage them, and with the default retention policy the StatefulSet controller keeps them when the StatefulSet is deleted.

### Services

`applications[].services[]` is a list. Service names must be unique in the release.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `name` | Exact Service name; required for every Service but the first | first Service: `<fullName>` |
| `type` | `ClusterIP`, `NodePort`, `LoadBalancer` | not set (Kubernetes uses `ClusterIP`) |
| `clusterIP` | e.g. `None` for a headless Service | |
| `ports[]` | `name`, `port`, `targetPort`, `protocol`, `nodePort` (NodePort only) | |
| `selectApp` | Select the pods of another application of this release (`appselector` + `app.kubernetes.io/instance`) | this application |
| `selector` | Raw label selector, used as is | |
| `externalIPs[]` / `externalTrafficPolicy` | As in Kubernetes | |
| `extraLabels` / `extraAnnotations` | Extra metadata | |

`selectApp` and `selector` are mutually exclusive; rendering fails for a `selectApp` that is not an application of the release.

### Ingress

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.apiVersion` / `ingress.kind` | API version and kind | `networking.k8s.io/v1`, `Ingress` |
| `ingress.extraAnnotations` | Annotations | `{}` |
| `ingress.useTLS` | Adds a TLS section with secret `<fullName>-tls` | `false` |
| `ingress.fqdn` | Host | |
| `ingress.ingressClassName` | Ingress class | `nginx` |
| `ingress.paths[].path` / `.pathType` | Path and path type | |
| `ingress.paths[].serviceName` | Any Service of this release; rendering fails for an unknown name | first Service of this application |
| `ingress.paths[].servicePortName` / `.servicePort` | Backend port by name (wins) or number | |

### ConfigMap

| Parameter | Description | Default |
|-----------|-------------|---------|
| `configMap.files[].name` / `.data` | Files of the ConfigMap `<fullName>` (set `data` with `--set-file`); files without `data` are skipped | `[]` |
| `configMap.extraLabels` / `.extraAnnotations` | Extra metadata | |

The pod gets the volume `volume-configs` with these files; mount it with `containers[].volumeMounts: [{name: volume-configs, mountPath: ...}]` in the containers that need it.

### Secret

| Parameter | Description | Default |
|-----------|-------------|---------|
| `secret.data` | YAML string of `key: value` pairs for the Secret `<fullName>`; rendering fails when it is not a YAML map | |
| `secret.extraLabels` / `.extraAnnotations` | Extra metadata | |

The pod gets the volume `volume-secrets`; mount it with `containers[].volumeMounts: [{name: volume-secrets, mountPath: ..., readOnly: true}]`, or read single keys with `envs[].valueFrom.secretKeyRef`.

### RBAC
To create a ServiceAccount without a Role, leave `rbac.rules` unset.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `rbac.create` | Create a ServiceAccount `<fullName>` (and Role/RoleBinding with `rules`) | `false` |
| `rbac.useExistingServiceAccount` | Use an existing ServiceAccount. Cannot be used with `create` | |
| `rbac.legacyToken` | Create a long-lived token Secret for the ServiceAccount | `false` |
| `rbac.rules[]` | `apiGroups`, `resources`, `verbs` | `[]` |
| `rbac.extraLabels` / `.extraAnnotations` | Extra metadata | |

### Monitoring

| Parameter | Description | Default |
|-----------|-------------|---------|
| `monitoring.prometheus[].name` | Name of the monitor (required); the object is `<fullName>-<name>` | |
| `monitoring.prometheus[].apiVersion` | API version | `monitoring.coreos.com/v1` |
| `monitoring.prometheus[].kind` | `ServiceMonitor` (selects the Services of this application) or `PodMonitor` (selects its pods) | `ServiceMonitor` |
| `monitoring.prometheus[].namespacesSelector[]` | Namespaces to watch | release namespace |
| `monitoring.prometheus[].endpoints[]` | `port`, `path` (`/metrics`), `interval` (`30s`), `scheme` (`http`); ServiceMonitor also `bearerTokenFile`, `honorLabels` (`true`) | |
| `monitoring.prometheus[].jobLabel` | Job label | `k8s-app` |

## Examples

The values files in [`tests/`](tests/) pass `helm lint . -f tests/<file>` and cover the common shapes:

- [`tests/simple-deployment.yaml`](tests/simple-deployment.yaml) - one Deployment behind one Service, no volumes
- [`tests/deployment-sidecar-pvcs.yaml`](tests/deployment-sidecar-pvcs.yaml) - a Deployment with a sidecar on two adopted claims, one Secret mounted twice with different `items`, two Services on the same pod, `Recreate` strategy
- [`tests/statefulset-standalone-pvcs.yaml`](tests/statefulset-standalone-pvcs.yaml) - a StatefulSet on standalone claims with init containers, a CronJob on emptyDirs, and a Service-only application selecting the StatefulSet
- [`tests/job-configmap-secret.yaml`](tests/job-configmap-secret.yaml) - a Job whose main container mounts the chart's ConfigMap and Secret, and a sidecar that does not
- [`tests/monitoring.yaml`](tests/monitoring.yaml) - a ServiceMonitor and a PodMonitor, each selecting its own application

A StatefulSet with a claim template:

```yaml
applications:
  - name: my-app
    app:
      type: statefulset
      containers:
        - name: my-app
          image:
            repository: registry.example.com/my-app
            tag: "1.0.0"
          volumeMounts:
            - name: data
              mountPath: /var/lib/my-app
      volumeClaimTemplates:
        - name: data              # claim data-my-app-0
          size: 1Gi
          storageClassName: standard
    services:
      - type: ClusterIP
        ports:
          - name: http
            port: 80
            targetPort: 8080
            protocol: TCP
```

## Migrating from 3.x

Object names and the Deployment/StatefulSet selectors stay the same, so a translated module upgrades in place.

| 3.x key | 4.x key |
|---------|---------|
| `service: {type, ports, ...}` | `services: [{type, ports, ...}]` - the first Service keeps the name `<fullName>` and the same selector |
| `app.emptyDirVolume: {name, sizeLimit, mountPath}` | `app.volumes: [{name, emptyDir: {sizeLimit}}]` + `containers[].volumeMounts: [{name, mountPath}]` |
| `app.persistentVolume` on a deployment/job/cronjob | `persistentVolumeClaims: [{name, size, storageClassName, accessModes}]` (claim `<fullName>-<name>` as before, or `claimName`) + `app.volumes: [{name, persistentVolumeClaim: {claimName: <fullName>-<name>}}]` + `containers[].volumeMounts` |
| `app.persistentVolume` on a statefulset | `app.volumeClaimTemplates: [{name, size, storageClassName, accessModes}]` + `containers[].volumeMounts` - claims stay `<name>-<fullName>-<ordinal>` |
| `app.externalSecrets: [{name, mountPath}]` | `app.volumes: [{name, secret: {secretName}}]` + `containers[].volumeMounts: [{name, mountPath, readOnly: true}]` |
| `app.externalConfigMaps: [{name, mountPath}]` | `app.volumes: [{name, configMap: {name}}]` + `containers[].volumeMounts: [{name, mountPath, readOnly: true}]` |
| `configMap.mountPath` (mounted into every container) | `containers[].volumeMounts: [{name: volume-configs, mountPath, readOnly: true}]` on each container that reads the files |
| `secret.mountPath` (mounted into every container) | `containers[].volumeMounts: [{name: volume-secrets, mountPath, readOnly: true}]` on each container that reads the Secret |
| `app.cronjob` (was never read) | `app.cronJob` |
| `app.probes`, `app.envs`, `app.resources` (were never applied) | `containers[].probes`, `containers[].envs`, `containers[].resources` |
| `ingress.paths[].serviceName` (was ignored) | now honoured: must name a Service of the release, or be left out |

Behaviour that changes with the same intent:

- 3.x mounted every volume into every container, init containers included. In 4.x a container mounts only its own `volumeMounts`: list the mount on each container that needs it.
- Pod templates no longer carry the chart version (`version`, `app.kubernetes.io/version`), so the first upgrade to 4.x restarts the pods once and later chart upgrades do not.
- Service and NetworkPolicy selectors add `app.kubernetes.io/instance: <release>` next to `appselector`; the pods already carry it.
- Job and CronJob pods carry the same labels as other pods of the chart.
- `app.extraAnnotations` go on the pod template for every workload type; 3.x put them on the StatefulSet and CronJob objects as well (CronJob: only there).
- Prometheus monitors are named `<fullName>-<name>` and select the Services or pods of their application; in 3.x the selector was built from the monitor name and matched nothing.
- Standalone claims get `helm.sh/resource-policy: keep` by default; set `keep: false` to let `helm uninstall` delete them.
- CronJob history limits default to `1` instead of `0`.
- A StatefulSet whose only volume was a claim template no longer renders an empty `volumes:` key.

`helm lint` fails on every removed or unknown key:

```text
[ERROR] values.yaml: - at '/applications/0': validation failed
  - at '/applications/0/app': additional properties 'persistentVolume' not allowed
  - at '/applications/0': additional properties 'service' not allowed
```

## Usage example for Gitlab-CI
**To work, you will also need to add vault-client and kubectl to the image**
```yaml
image: alpine/helm
stages:
  - deploy

deploy-helm:
  stage: deploy
  variables:
    HELM_RELEASE_NAMESPACE: default
  before_script:
    # We collect the release name for the helm chart and bring everything to lowercase
    - export HELM_RELEASE_NAME=`echo $CI_PROJECT_NAME-$CI_COMMIT_REF_SLUG | tr '[:upper:]' '[:lower:]'`
    # Log in to vault and get secret environment variables in key: value format from vault
    - export VAULT_ADDR=https://vault.example.com/
    - export VAULT_TOKEN="$(vault write -field=token auth/jwt/login role=vault-role jwt=$CI_JOB_JWT)"
    - vault kv get -format=yaml -field=data bucket1/secret1 > .helm/vault.secret.yaml
  script:
    - helm repo add obervinov https://obervinov.github.io/helm-charts
    # Example of adding the contents of an external config from your repository
    # --set-file "applications[0].configMap.files[0].data"="config/config.json"
    # Example of adding secret contents unloaded from vault
    # --set-file "applications[0].secret.data"=".helm/vault.secret.yaml"
    # -f .helm/values.yaml - path to the values file in your repository
    - |
      helm upgrade --install ${HELM_RELEASE_NAME} obervinov/universal-template \
        --set-file "applications[0].configMap.files[0].data"="config/config.json" \
        --set-file "applications[0].secret.data"=".helm/vault.secret.yaml" \
        --namespace=${HELM_RELEASE_NAMESPACE} -f .helm/values.yaml
  after_script:
    # Running helm tests
    - helm test ${HELM_RELEASE_NAME} -n ${HELM_RELEASE_NAMESPACE} --logs
```

### Step-by-step description
1. Generating the release name that will be required for the team `helm install`
```bash
export HELM_RELEASE_NAME=`echo $CI_PROJECT_NAME-$CI_COMMIT_REF_SLUG | tr '[:upper:]' '[:lower:]'`
```
2. Uploading secrets from the vault to a yaml file
```bash
export VAULT_ADDR=https://vault.example.com/
export VAULT_TOKEN="$(vault write -field=token auth/jwt/login role=vault-role jwt=$CI_JOB_JWT)"
vault kv get -format=yaml -field=data bucket1/secret1 > .helm/vault.secret.yaml
```
3. Connecting the helm package registry with the chart
```bash
helm repo add obervinov https://obervinov.github.io/helm-charts
helm repo update
```
4. Creating your own file `values.yaml`
5. We are installing a release from this chart
```bash
# ${HELM_RELEASE_NAME} - release name, consisting of the project name and the name of the current branch in gtilab
# obervinov/universal-template - link to the package in the connected repository
# --set-file "applications[0].configMap.files[0].data"="config/config.json" - we throw the contents of the external config into the chart
# --set-file "applications[0].secret.data"=".helm/vault.secret..yaml" - we forward the data received from the volt to the chart
# --namespace=${HELM_RELEASE_NAMESPACE} - namespace in the kube to install the chart
# -f .helm/values.yaml - a link to the values file created in the previous step
helm upgrade --install ${HELM_RELEASE_NAME} obervinov/universal-template --set-file "applications[0].configMap.files[0].data"="config/config.json" --set-file "applications[0].secret.data"=".helm/vault.secret.yaml" --namespace=${HELM_RELEASE_NAMESPACE} -f .helm/values.yaml
```
