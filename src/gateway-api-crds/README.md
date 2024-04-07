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
| `brotli.enabled`                   | Enable Brotli compression         | `true`                   |
| `brotli.chunkSize`                 | Brotli chunk size                 | `4096`                   |
| `brotli.encoderMode`               | Brotli encoder mode               | `DEFAULT`                |
| `brotli.inputBlockBits`            | Brotli input block bits           | `24`                     |
| `brotli.quality`                   | Brotli quality                    | `5`                      |
| `brotli.windowBits`                | Brotli window bits                | `18`                     |
| `brotli.minContentLength`          | Brotli minimum content length     | `800`                    |
| `brotli.contentType`               | Content types to compress         | `application/json`, `text/css`, `text/html`, `text/plain`, `text/xml` |
| `accessLogs.enabled`               | Enable access logs                | `true`                   |
| `gateways[].name`                  | Name of the gateway               | `private`/`public`       |
| `gateways[].hostname`              | Hostname for the gateway          | `*.example.internal`/`*.example.cloud` |
| `gateways[].proxyProtocolV2`       | Whether to use Proxy Protocol V2  | `true`                   |
| `gateways[].gatewayClass`          | Gateway class to use              | `istio`                  |
| `gateways[].extraAnnotations`      | Additional annotations for the gateway | `{}`               |
| `gateways[].allowedNamespaces`     | Namespaces allowed to use the gateway | `istio-system`, `default` |
| `gateways[].listeners[].name`      | Name of the listener              | `http`/`https`           |
| `gateways[].listeners[].port`      | Port for the listener             | `80`/`443`               |
| `gateways[].listeners[].protocol`  | Protocol for the listener         | `HTTP`/`HTTPS`           |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm install my-release . --set gateways[0].name=private,gateways[0].hostname=*.example.internal
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
helm install my-release -f values.yaml .
```

## Templates
1. `envoyfilters-brotli.yaml`: This template creates an EnvoyFilter resource that adds Brotli compression to the HTTP traffic. The Brotli settings such as chunk size, encoder mode, input block bits, quality, window bits, minimum content length, and content type are configurable through the values.yaml file.

2. `envoyfilters-proxyv2.yaml`: This template creates an EnvoyFilter resource for each gateway that has the proxyProtocolV2 enabled. The filter adds the Proxy Protocol v2 and TLS inspector to the listener filters. If any of the gateways have proxyProtocolV2 enabled, an additional EnvoyFilter is created to configure the HTTP connection manager.

3. `gateways.yaml`: This template creates a Gateway resource for each entry in the gateways list in the values.yaml file. The gateway's name, hostname, gateway class, extra annotations, listeners, service type, proxy protocol, and allowed namespaces are configurable through the values.yaml file.

4. `telemetry-logs.yaml`: This template creates a Telemetry resource that enables access logging if the accessLogs.enabled option is set to true in the values.yaml file.
