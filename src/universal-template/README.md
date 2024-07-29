# Universal Helm Chart for Kubernetes Applications

This Helm chart provides a universal template for deploying applications on Kubernetes. It encompasses various resources such as deployments, services, ingresses, configmaps, secrets, RBAC, and monitoring configurations.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Extended Configuration](#extended-configuration)
- [Usage](#usage)
- [Examples](#examples)
- [Contributing](#contributing)
- [License](#license)

## Overview

This Helm chart enables you to deploy applications on Kubernetes with ease. It includes configurations for different types of applications, services, ingresses, and more. You can customize each component according to your requirements using Helm values.

## Prerequisites

- Kubernetes cluster
- Helm installed

## Installation

To install the chart, use the following command:

```bash
helm install <release-name> <chart-name>
```

## Configuration

The following table lists the configurable parameters of the chart and their default values:

### Applications

| Parameter             | Description                                                                 | Default                |
|-----------------------|-----------------------------------------------------------------------------|------------------------|
| `applications`        | List of application configurations                                          | `[]`                   |
| `applications.name`   | Name of the application                                                     | `""`                   |
| `applications.app.type` | Type of application (Deployment, StatefulSet, Job, CronJob)              | `deployment`           |
| `applications.app.replicas` | Number of replicas                                                   | `1`                    |
| `applications.app.extraLabels` | Additional labels for the application                              | `{}`                   |
| `applications.app.extraAnnotations` | Additional annotations for the application                   | `{}`                   |
| `applications.app.containers` | List of container configurations                                    | `[]`                   |
| `applications.app.containers.name` | Name of the container                                         | `""`                   |
| `applications.app.containers.image.repository` | Image repository                                  | `""`                   |
| `applications.app.containers.image.tag` | Image tag                                                 | `""`                   |
| `applications.app.containers.image.pullPolicy` | Image pull policy                                 | `IfNotPresent`         |
| `applications.app.containers.image.pullSecrets` | List of image pull secrets                        | `[]`                   |
| `applications.app.containers.commands` | List of commands to run in the container                   | `[]`                   |
| `applications.app.containers.args` | List of arguments for the container commands                  | `[]`                   |
| `applications.app.containers.envs` | List of environment variables for the container               | `[]`                   |
| `applications.app.containers.envs.name` | Environment variable name                                 | `""`                   |
| `applications.app.containers.envs.value` | Environment variable value                               | `""`                   |
| `applications.app.containers.envs.valueFrom` | Source of the environment variable value (e.g., secretKeyRef, fieldRef) | `{}` |
| `applications.app.containers.resources.requests.memory` | Requested memory                         | `256Mi`                |
| `applications.app.containers.resources.requests.cpu` | Requested CPU                                 | `250m`                 |
| `applications.app.containers.resources.limits.memory` | Memory limit                               | `512Mi`                |
| `applications.app.containers.resources.limits.cpu` | CPU limit                                    | `500m`                 |
| `applications.app.initContainers` | List of init container configurations                         | `[]`                   |
| `applications.app.emptyDirVolume` | Configuration for emptyDir volume                             | `{}`                   |
| `applications.app.persistentVolume` | Configuration for persistent volume                         | `{}`                   |
| `applications.app.externalSecrets` | Mounting external secrets                                    | `[]`                   |
| `applications.app.externalConfigMaps` | Mounting external configmaps                              | `[]`                   |
| `applications.app.affinity` | Affinity rules for the application                                 | `{}`                   |
| `applications.app.nodeSelector` | Node selector for the application                              | `{}`                   |
| `applications.app.tolerations` | Tolerations for the application                                  | `[]`                   |
| `applications.app.probes.livenessProbe` | Liveness probe configuration                            | `{}`                   |
| `applications.app.probes.readinessProbe` | Readiness probe configuration                        | `{}`                   |
| `applications.app.probes.startupProbe` | Startup probe configuration                                | `{}`                   |
| `applications.app.cronjob` | CronJob specific configuration (only for batch applications and cronjobs) | `{}` |
| `applications.app.job` | Job specific configuration (only for batch applications and jobs)        | `{}`                   |

### Service

| Parameter                           | Description                                                                 | Default    |
|-------------------------------------|-----------------------------------------------------------------------------|------------|
| `applications.service.externalTrafficPolicy` | External traffic policy for the service                                    | `Cluster`  |
| `applications.service.externalIPs` | External IPs for the service                                                | `[]`       |
| `applications.service.extraAnnotations` | Additional annotations for the service                                     | `{}`       |
| `applications.service.type` | Type of service (ClusterIP, NodePort, LoadBalancer)                           | `ClusterIP` |
| `applications.service.ports` | List of service ports                                                       | `[]`       |
| `applications.service.ports.name` | Name of the service port                                                   | `""`       |
| `applications.service.ports.port` | Port number for the service                                                | `80`       |
| `applications.service.ports.protocol` | Protocol for the service port                                             | `TCP`      |
| `applications.service.ports.targetPort` | Target port for the service                                               | `80`       |

### Ingress

| Parameter                           | Description                                                                 | Default    |
|-------------------------------------|-----------------------------------------------------------------------------|------------|
| `applications.ingress.apiVersion` | API version for the ingress                                                 | `networking.k8s.io/v1` |
| `applications.ingress.kind` | Kind of the ingress                                                         | `Ingress`  |
| `applications.ingress.extraAnnotations` | Additional annotations for the ingress                                     | `{}`       |
| `applications.ingress.useTLS` | Use TLS for the ingress                                                     | `true`     |
| `applications.ingress.fqdn` | Fully qualified domain name for the ingress                                   | `""`       |
| `applications.ingress.paths` | List of ingress paths                                                       | `[]`       |
| `applications.ingress.paths.path` | Path for the ingress                                                       | `/`        |
| `applications.ingress.paths.pathType` | Path type for the ingress                                                 | `Prefix`   |
| `applications.ingress.paths.servicePort` | Service port for the ingress                                              | `80`       |
| `applications.ingress.paths.serviceName` | Service name for the ingress                                              | `""`       |
| `applications.ingress.ingressClassName` | Ingress class name                                                        | `nginx`    |

### ConfigMap

| Parameter                           | Description                                                                 | Default    |
|-------------------------------------|-----------------------------------------------------------------------------|------------|
| `applications.configMap.mountPath` | Path in the container where the config maps will be mounted                | `""`       |
| `applications.configMap.files` | List of config files                                                       | `[]`       |
| `applications.configMap.files.name` | Name of the config file                                                    | `""`       |
| `applications.configMap.files.data` | Data for the config file                                                   | `{}`       |

### Secret

| Parameter                           | Description                                                                 | Default    |
|-------------------------------------|-----------------------------------------------------------------------------|------------|
| `applications.secret.mountPath` | Path in the container where the secrets will be mounted                    | `""`       |
| `applications.secret.data` | Data for the secrets                                                       | `{}`       |

### RBAC
For create ServiceAccount without Role, just not set `applications.rbac.rules` parameter.

| Parameter                           | Description                                                                 | Default    |
|-------------------------------------|-----------------------------------------------------------------------------|------------|
| `applications.rbac.create` | Create RBAC resources                                                         | `false`    |
| `applications.rbac.existingServiceAccount` | Use existing ServiceAccount for the RBAC resources. Cannot be used with `create` | `""`       |
| `applications.rbac.legacyToken` | Use legacy token for the RBAC resources. Cannot be used with `create`        | `false`    |
| `applications.rbac.rules` | List of RBAC rules                                                             | `[]`       |
| `applications.rbac.rules.apiGroups` | API groups for the RBAC rules                                              | `[""]`     |
| `applications.rbac.rules.resources` | Resources for the RBAC rules                                               | `["pods"]` |
| `applications.rbac.rules.verbs` | Verbs for the RBAC rules                                                   | `["get", "watch", "list"]` |

### Monitoring

| Parameter                           | Description                                                                 | Default    |
|-------------------------------------|-----------------------------------------------------------------------------|------------|
| `applications.monitoring.prometheus` | List of Prometheus monitoring configurations                               | `[]`       |
| `applications.monitoring.prometheus.name` | Name of the Prometheus configuration                                    | `""`       |
| `applications.monitoring.prometheus.apiVersion` | API version for the Prometheus configuration                             | `monitoring.coreos.com/v1` |
| `applications.monitoring.prometheus.kind` | Kind of the Prometheus configuration                                     | `ServiceMonitor` |
| `applications.monitoring.prometheus.namespacesSelector` | Namespace selector for the Prometheus configuration                       | `[]`       |
| `applications.monitoring.prometheus.endpoints` | List of endpoints for the Prometheus configuration                       | `[]`       |
| `applications.monitoring.prometheus.endpoints.port` | Port for the Prometheus endpoint                                         | `http`     |
| `applications.monitoring.prometheus.endpoints.path` | Path for the Prometheus endpoint                                         | `/metrics` |
| `applications.monitoring.prometheus.endpoints.interval` | Interval for the Prometheus endpoint                                     | `15s`      |
| `applications.monitoring.prometheus.endpoints.scheme` | Scheme for the Prometheus endpoint                                       | `http`     |

## Usage

To use this Helm chart, follow these steps:

1. Prepare your application configurations.
2. Modify the `values.yaml` file according to your requirements.
3. Install the chart using the `helm install` command.

## Examples

Here's an example of how to deploy a simple application using this Helm chart:

```yaml
---
applications:
  - name: statefulset-app
    app:
      type: statefulset
      replicas: 1
      extraLabels:
        app.kubernetes.io/instance: "statefulset-app"
      extraAnnotations:
        checksum/values.yaml: "helm/values.yaml"
      containers:
        - name: container1
          image:
            repository: "my-registry/app1"
            tag: "1.0.0"
            pullPolicy: IfNotPresent
            pullSecrets:
              - my-secret
            commands:
              - bash
            args:
              - -c
              - env
          envs:
            - name: LOG_LEVEL
              value: INFO
            - name: SECRET_USERNAME
              valueFrom:
                secretKeyRef:
                  name: my-secret
                  key: username
            - name: NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
          resources:
            requests:
              memory: "256Mi"
              cpu: "250m"
            limits:
              memory: "512Mi"
              cpu: "500m"
      initContainers:
        - name: init-container1
          image:
            repository: "my-registry/init-container1"
            tag: "1.0.0"
            pullPolicy: IfNotPresent
            pullSecrets:
              - my-secret
          envs:
            - name: LOG_LEVEL
              value: INFO
          resources:
            requests:
              memory: "256Mi"
              cpu: "250m"
            limits:
              memory: "512Mi"
              cpu: "500m"
      emptyDirVolume:
        name: "data"
        medium: ""
        sizeLimit: "1Gi"
        mountPath: "/data"
      persistentVolume:
        name: "data"
        size: 1Gi
        accessModes: [ "ReadWriteOnce" ]
        storageClassName: "standard"
        mountPath: "/data"
      externalSecrets:
        - name: my-external-secret
          mountPath: "/external-secrets"
      externalConfigMaps:
        - name: my-external-config
          mountPath: "/external-configs"
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
              - matchExpressions:
                  - key: kubernetes.io/e2e-az-name
                    operator: In
                    values:
                      - e2e-az1
      nodeSelector:
        disktype: ssd
      tolerations:
        - key: "key"
          operator: "Equal"
          value: "value"
          effect: "NoSchedule"
      probes:
        livenessProbe:
          httpGet:
            path: /health/liveness
            port: 80
          initialDelaySeconds: 30
          periodSeconds: 5
          timeoutSeconds: 5
          successThreshold: 1
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /health/readiness
            port: 80
          initialDelaySeconds: 15
          periodSeconds: 5
          timeoutSeconds: 5
          successThreshold: 1
          failureThreshold: 3
        startupProbe:
          httpGet:
            path: /health/startup
            port: 80
          initialDelaySeconds: 15
          periodSeconds: 10
          timeoutSeconds: 1
          successThreshold: 1
          failureThreshold: 3
    service:
      externalTrafficPolicy: Cluster
      externalIPs:
        - 1.1.1.1
      extraAnnotations:
        checksum/values.yaml: "helm/values.yaml"
      type: ClusterIP
      ports:
        - name: http
          port: 80
          protocol: TCP
          targetPort: 80
    ingress:
      apiVersion: networking.k8s.io/v1
      kind: Ingress
      extraAnnotations:
        checksum/values.yaml: "helm/values.yaml"
      useTLS: true
      fqdn: my-service.example.com
      paths:
        - path: /
          pathType: Prefix
          servicePort: 80
          serviceName: app1
      ingressClassName: nginx
    configMap:
      mountPath: "/configs"
      files:
        - name: "config.json"
          data: |
            {
              "key": "value"
            }
    secret:
      mountPath: "/secrets"
      data: |
        key1: "value1"
        key2: "value2"
    rbac:
      legacyToken: true
      rules:
        - apiGroups:
            - ""
          resources:
            - pods
          verbs:
            - get
            - watch
            - list
    monitoring:
      prometheus:
        - name: ServiceMonitor1
          apiVersion: monitoring.coreos.com/v1
          kind: ServiceMonitor
          namespacesSelector:
            - monitoring
          endpoints:
            - port: http
              path: /metrics
              interval: 15s
              scheme: http
        - name: PodMonitor1
          apiVersion: monitoring.coreos.com/v1
          kind: PodMonitor
          namespacesSelector:
            - monitoring
          endpoints:
            - port: http
              path: /metrics
              interval: 15s
              scheme: http
```

## Contributing

Contributions are welcome! Feel free to submit issues and pull requests.


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
    # --set-file "applications[0].configmap[0].data"="config/config.json"
    # Example of adding secret contents unloaded from vault
    # --set-file "applications[0].secret.data"=".helm/vault.secret.yaml"
    # -f .helm/values.yaml - устанавливаем путь к values.yaml файлу в вашем реппозитории
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
# --set-file "applications[0].configmap[0].data"="config/config.json" - we throw the contents of the external config into the chart
# --set-file "applications[0].secret.data"=".helm/vault.secret..yaml" - we forward the data received from the volt to the chart
# --namespace=${HELM_RELEASE_NAMESPACE} - namespace in the kube to install the chart
# -f .helm/values.yaml - a link to the values file created in the previous step
helm upgrade --install ${HELM_RELEASE_NAME} obervinov/universal-template --set-file "applications[0].configMap.files[0].data"="config/config.json" --set-file "applications[0].secret.data"=".helm/vault.secret.yaml" --namespace=${HELM_RELEASE_NAMESPACE} -f .helm/values.yaml
```
