# WireGuard Operator CRDs Helm Chart

## Introduction
This chart deploys the WireGuard Operator CRDs from the https://github.com/jodevsa/wireguard-operator repository on a Kubernetes cluster using the Helm package manager.

## Prerequisites
- Kubernetes 1.30+
- Helm 3.11.1+

## Installing the Chart
To install the chart with the release name `wireguard-operator-crds`:

```bash
helm repo add obervinov https://obervinov.github.io/helm-charts/
# or
helm repo add obervinov oci://ghcr.io/obervinov/helm-charts
helm repo update
helm install wireguard-operator-crds obervinov/wireguard-operator-crds
```


## Configuration

The following table lists the configurable parameters of the WireGuard Operator CRDs chart and their default values.
| Parameter                                | Description                                                                                       |
|------------------------------------------|---------------------------------------------------------------------------------------------------|
| `fullnameOverride`                       | Full name to override the generated name for deployment                                            |
| `wireguards`                             | List of WireGuard instances                                                                        |
| `wireguards[0].name`                     | Name of the first WireGuard instance                                                               |
| `wireguards[0].mtu`                      | MTU for the first instance                                                                         |
| `wireguards[0].nodePort`                 | NodePort for the first instance                                                                    |
| `wireguards[0].address`                  | Address for the first WireGuard instance                                                           |
| `wireguards[0].agent.resources.limits.cpu`    | CPU limits for the agent of the first instance                                                 |
| `wireguards[0].agent.resources.limits.memory` | Memory limits for the agent of the first instance                                              |
| `wireguards[0].agent.resources.requests.cpu`  | CPU requests for the agent of the first instance                                                |
| `wireguards[0].agent.resources.requests.memory`| Memory requests for the agent of the first instance                                             |
| `wireguards[0].dns`                      | DNS for the first instance                                                                         |
| `wireguards[0].metric.resources.limits.cpu`    | CPU limits for metrics of the first instance                                                   |
| `wireguards[0].metric.resources.limits.memory` | Memory limits for metrics of the first instance                                                |
| `wireguards[0].metric.resources.requests.cpu`  | CPU requests for metrics of the first instance                                                  |
| `wireguards[0].metric.resources.requests.memory`| Memory requests for metrics of the first instance                                               |
| `peers`                                  | List of WireGuard peers                                                                            |
| `peers[0].name`                          | Name of the first peer                                                                             |
| `peers[0].wireguardRef`                  | Reference to the WireGuard instance for the first peer                                             |
| `peers[0].address`                       | Address for the first peer                                                                         |
| `peers[0].allowedIPs`                    | Allowed IPs for the first peer                                                                     |
| `peers[0].disabled`                      | Whether the first peer is disabled                                                                 |
| `peers[0].dns`                           | DNS for the first peer                                                                             |
| `peers[0].privateKeyRef`                 | Reference to the private key for the first peer                                                    |
| `peers[0].publicKey`                     | Public key for the first peer                                                                      |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm install wireguard-operator-crds obervinov/wireguard-operator-crds --set wireguards[0].name=wg0,wireguards[0].mtu=1380,wireguards[0].nodePort=true,peers[0].name=peer0,peers[0].wireguardRef=wg0
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
helm install wireguard-operator-crds obervinov/wireguard-operator-crds -f values.yaml
```

## Resources list
- `vpn.wireguard-operator.io_wireguardpeers`
- `vpn.wireguard-operator.io_wireguards`