# WireGuard Operator Helm Chart

## Introduction
This chart bootstraps the WireGuard Operator from the https://github.com/jodevsa/wireguard-operator repository on a Kubernetes cluster using the Helm package manager.
Chart already contains the WireGuard Operator CRDs and the WireGuard Operator itself.

## Prerequisites
- Kubernetes 1.30+
- Helm 3.11.1+

## Installing the Chart
To install the chart with the release name `wireguard-operator`:

```bash
helm repo add obervinov https://obervinov.github.io/helm-charts/
# or
helm repo add obervinov oci://ghcr.io/obervinov/helm-charts
helm repo update
helm install wireguard-operator obervinov/wireguard-operator
```


## Configuration

The following table lists the configurable parameters of the WireGuard Operator chart and their default values.

| **Parameter**             | **Description**                                                   | **Default Value**                              |
|---------------------------|-------------------------------------------------------------------|------------------------------------------------|
| `proxy.image.repository`   | Repository for the kube-rbac-proxy sidecar container image        | `gcr.io/kubebuilder/kube-rbac-proxy`          |
| `proxy.image.tag`          | Tag/version for the kube-rbac-proxy sidecar container image       | `v0.8.0`                                       |
| `proxy.resources.limits.cpu`   | CPU resource limit for the kube-rbac-proxy sidecar               | `0`                                            |
| `proxy.resources.limits.memory`| Memory resource limit for the kube-rbac-proxy sidecar            | `128Mi`                                        |
| `proxy.resources.requests.cpu` | CPU resource request for the kube-rbac-proxy sidecar              | `0`                                            |
| `proxy.resources.requests.memory`| Memory resource request for the kube-rbac-proxy sidecar         | `64Mi`                                         |
| `agent.image.repository`   | Repository for the WireGuard agent sidecar container image       | `ghcr.io/jodevsa/wireguard-operator/agent`     |
| `agent.image.tag`          | Tag/version for the WireGuard agent sidecar container image      | `v2.7.0`                                       |
| `image.repository`         | Repository for the WireGuard manager container image             | `ghcr.io/jodevsa/wireguard-operator/manager`   |
| `image.tag`                | Tag/version for the WireGuard manager container image            | `v2.7.0`                                       |
| `resources.limits.cpu`     | CPU resource limit for the WireGuard manager container           | `0`                                            |
| `resources.limits.memory`  | Memory resource limit for the WireGuard manager container        | `128Mi`                                        |
| `resources.requests.cpu`   | CPU resource request for the WireGuard manager container         | `0`                                            |
| `resources.requests.memory`| Memory resource request for the WireGuard manager container      | `64Mi`                                         |
| `replicas`                 | Number of replicas for the WireGuard manager Deployment          | `1`                                            |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm install wireguard-operator obervinov/wireguard-operator --set proxy.image.tag=v0.8.0,agent.image.tag=v2.7.0,image.tag=v2.7.0
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
helm install wireguard-operator obervinov/wireguard-operator -f values.yaml
```

## Resources list
- `Deployment`
- `Service`
- `ServiceAccount`
- `ClusterRole`
- `ClusterRoleBinding`  
- `Role`
- `RoleBinding`
- `ConfigMap`

# CRDs list
- `vpn.wireguard-operator.io_wireguardpeers`
- `vpn.wireguard-operator.io_wireguards`