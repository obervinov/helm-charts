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

| **Parameter**                 | **Description**                                                       | **Default Value** |
|-------------------------------|-----------------------------------------------------------------------|-------------------|
| `wireguards`                  | A dictionary defining WireGuard instances                             | N/A               |
| `wireguards[0].name`          | Name of the first WireGuard instance                                  | N/A               |
| `wireguards[0].mtu`           | Maximum Transmission Unit (MTU) size for the first WireGuard instance | N/A               |
| `wireguards[0].nodePort`      | Whether to use a NodePort for the first WireGuard instance            | N/A               |
| `peers`                       | A dictionary defining WireGuard peers                                 | N/A               |
| `peers[0].name`               | Name of the first WireGuard peer                                      | N/A               |
| `peers[0].wireguardRef`       | Reference to the WireGuard instance for the first peer                | N/A               |


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