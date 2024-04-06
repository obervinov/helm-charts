# Universal Helm Chart for Kubernetes Applications

This Helm chart provides a universal template for deploying applications on Kubernetes. It encompasses various resources such as deployments, services, ingresses, configmaps, secrets, RBAC, and monitoring configurations.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
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

| Parameter                   | Description                               | Default                            |
|-----------------------------|-------------------------------------------|------------------------------------|
| `applications`              | List of application configurations       | See values.yaml                    |
| `service`                   | Service configuration                      | See values.yaml                    |
| `ingress`                   | Ingress configuration                      | See values.yaml                    |
| `configmap`                 | ConfigMap configuration                    | See values.yaml                    |
| `secret`                    | Secret configuration                       | See values.yaml                    |
| `rbac`                      | RBAC configuration                         | See values.yaml                    |
| `monitoring`                | Monitoring configuration                   | See values.yaml                    |

## Extended Configuration

The following table lists the configurable parameters of the chart and their default values:

### Global Parameters

| Parameter             | Description                                   | Default                  |
|-----------------------|-----------------------------------------------|--------------------------|
| `global.namespace`    | Namespace for resources                      | `default`                |
| `global.imagePullSecrets` | List of image pull secrets                | `[]`                     |
| `global.extraVolumeMounts` | Additional volume mounts for all applications | `[]`                   |
| `global.extraVolumes` | Additional volumes for all applications      | `[]`                     |

### Applications

| Parameter                   | Description                               | Default                            |
|-----------------------------|-------------------------------------------|------------------------------------|
| `applications`              | List of application configurations       | `[]`                               |

#### Application Parameters

| Parameter                   | Description                               | Default                            |
|-----------------------------|-------------------------------------------|------------------------------------|
| `name`                      | Name of the application                   | `""`                               |
| `app.type`                  | Type of application (deployment, statefulset, job, cronjob) | `deployment`        |
| `app.extraLabels`           | Additional labels for the application     | `{}`                               |
| `app.replicas`              | Number of replicas for the application    | `1`                                |
| `app.extraAnnotations`      | Additional annotations for the application| `{}`                               |
| `app.image.repository`      | Image repository                          | `""`                               |
| `app.image.tag`             | Image tag                                 | `""`                               |
| `app.image.pullPolicy`      | Image pull policy                         | `IfNotPresent`                     |
| `app.image.pullSecrets`     | List of image pull secrets                | `[]`                               |
| `app.image.commands`        | Commands to run in the container          | `[]`                               |
| `app.image.args`            | Arguments for the commands                | `[]`                               |
| `app.envs`                  | Environment variables                     | `[]`                               |
| `app.resources`             | Resource requests and limits              | `{}`                               |
| `app.persistentVolumes`     | Persistent volumes                        | `[]`                               |
| `app.affinity`              | Pod affinity                              | `{}`                               |
| `app.nodeSelector`          | Node selector                             | `{}`                               |
| `app.tolerations`           | Tolerations                               | `[]`                               |
| `app.probes`                | Probes configuration                      | `{}`                               |
| `app.job`                   | Job configuration                         | `{}`                               |
| `app.cronjob`               | CronJob configuration                     | `{}`                               |

### Service

| Parameter                   | Description                               | Default                            |
|-----------------------------|-------------------------------------------|------------------------------------|
| `service`                   | Service configuration                      | `{}`                               |

#### Service Parameters

| Parameter                   | Description                               | Default                            |
|-----------------------------|-------------------------------------------|------------------------------------|
| `service.type`              | Type of service (ClusterIP, NodePort, LoadBalancer) | `ClusterIP`            |
| `service.ports`             | Ports exposed by the service              | `[]`                               |
| `service.externalTrafficPolicy` | External traffic policy                 | `Cluster`                          |
| `service.externalIPs`       | External IPs for the service              | `[]`                               |
| `service.extraAnnotations`  | Additional annotations for the service    | `{}`                               |

### Ingress

| Parameter                   | Description                               | Default                            |
|-----------------------------|-------------------------------------------|------------------------------------|
| `ingress`                   | Ingress configuration                     | `{}`                               |

#### Ingress Parameters

| Parameter                   | Description                               | Default                            |
|-----------------------------|-------------------------------------------|------------------------------------|
| `ingress.apiVersion`        | API version for the ingress resource      | `networking.k8s.io/v1`            |
| `ingress.kind`              | Kind of the ingress resource              | `Ingress`                          |
| `ingress.extraAnnotations`  | Additional annotations for the ingress    | `{}`                               |
| `ingress.useTLS`            | Enable TLS for the ingress                | `false`                            |
| `ingress.fqdn`              | Fully qualified domain name (FQDN)        | `""`                               |
| `ingress.paths`             | Paths for routing traffic                 | `[]`                               |
| `ingress.ingressClassName`  | Ingress class name                        | `""`                               |

### ConfigMap

| Parameter                   | Description                               | Default                            |
|-----------------------------|-------------------------------------------|------------------------------------|
| `configmap`                 | ConfigMap configuration                   | `{}`                               |

#### ConfigMap Parameters

| Parameter                   | Description                               | Default                            |
|-----------------------------|-------------------------------------------|------------------------------------|
| `configmap.mountPath`       | Mount path for the config files           | `""`                               |
| `configmap.files`           | List of files in the ConfigMap            | `[]`                               |

### Secret

| Parameter                   | Description                               | Default                            |
|-----------------------------|-------------------------------------------|------------------------------------|
| `secret`                    | Secret configuration                      | `{}`                               |

### RBAC

| Parameter                   | Description                               | Default                            |
|-----------------------------|-------------------------------------------|------------------------------------|
| `rbac`                      | RBAC configuration                        | `[]`                               |

#### RBAC Parameters

| Parameter                   | Description                               | Default                            |
|-----------------------------|-------------------------------------------|------------------------------------|
| `rbac.rules`                | RBAC rules                                | `[]`                               |

### Monitoring

| Parameter                   | Description                               | Default                            |
|-----------------------------|-------------------------------------------|------------------------------------|
| `monitoring`                | Monitoring configuration                  | `[]`                               |

#### Monitoring Parameters

| Parameter                   | Description                               | Default                            |
|-----------------------------|-------------------------------------------|------------------------------------|
| `monitoring.prometheus`     | Prometheus configuration                  | `[]`                               |

## Usage

To use this Helm chart, follow these steps:

1. Prepare your application configurations.
2. Modify the `values.yaml` file according to your requirements.
3. Install the chart using the `helm install` command.

## Examples

Here's an example of how to deploy a simple application using this Helm chart:

```yaml
applications:
  - name: app1
    app:
      type: deployment
      replicas: 1
      image:
        repository: "my-registry/app1"
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
    service:
      type: ClusterIP
      ports:
        - name: http
          port: 80
          protocol: TCP
          targetPort: 80
    ingress:
      useTLS: true
      fqdn: my-service.example.com
      paths:
        - path: /
          pathType: Prefix
          servicePort: 80
          serviceName: app1
      ingressClassName: nginx
```

## Contributing

Contributions are welcome! Feel free to submit issues and pull requests.

## License

This project is licensed under the [MIT License](LICENSE).


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
        --set-file "applications[0].configmap[0].data"="config/config.json" \
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
helm upgrade --install ${HELM_RELEASE_NAME} obervinov/universal-template --set-file "applications[0].configmap[0].data"="config/config.json" --set-file "applications[0].secret.data"=".helm/vault.secret.yaml" --namespace=${HELM_RELEASE_NAMESPACE} -f .helm/values.yaml
```
