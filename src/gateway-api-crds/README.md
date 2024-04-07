# Gateway-API Helm Chart

## Introduction

This chart bootstraps a Gateway-API deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. It creates Gateway and EnvoyFilter resources.

## Prerequisites

- Kubernetes 1.21+
- Helm 3.11.1+

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
helm install my-release .
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
helm delete my-release
```

## Configuration

The following table lists the configurable parameters of the Gateway-API chart and their default values.

| Parameter                          | Description                       | Default                  |
| ---------------------------------- | --------------------------------- | ------------------------ |
| `gateways[].name`                  | Name of the gateway               | ex. `gateway1`           |
| `gateways[].hostname`              | Hostname for the gateway          | `*.example.com`/`*.example.com` |
| `gateways[].gatewayClass`          | Gateway class to use              | `istio`                  |
| `gateways[].extraAnnotations`      | Additional annotations for the gateway | `{}`               |
| `gateways[].allowedNamespaces`     | Namespaces allowed to use the gateway |  `default` |
| `gateways[].listeners[].name`      | Name of the listener              | `http`/`https`           |
| `gateways[].listeners[].port`      | Port for the listener             | `80`/`443`               |
| `gateways[].listeners[].protocol`  | Protocol for the listener         | `HTTP`/`HTTPS`           |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm install my-release . --set gateways[0].name=gateway1,gateways[0].hostname=*.example.com
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
helm install my-release -f values.yaml .
```

## Templates
1. `gateways.yaml`: This template creates a Gateway resource for each entry in the gateways list in the values.yaml file. The gateway's name, hostname, gateway class, extra annotations, listeners, service type, proxy protocol, and allowed namespaces are configurable through the values.yaml file.
