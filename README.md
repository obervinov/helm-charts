# <img src="https://github.com/obervinov/content/blob/main/ico/1945958.png" width="30">  obervinov's helm-charts
This repository contains helm charts for all occasions.

This is a helm-registry for storing my helm-packages.

[![pages-build-deployment](https://github.com/obervinov/helm-charts/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/obervinov/helm-charts/actions/workflows/pages/pages-build-deployment) [![Checks and Build Helm-Charts Bundle](https://github.com/obervinov/helm-charts/actions/workflows/pr.yaml/badge.svg)](https://github.com/obervinov/helm-charts/actions/workflows/pr.yaml) [![Create GitHub Release](https://github.com/obervinov/helm-charts/actions/workflows/release.yaml/badge.svg)](https://github.com/obervinov/helm-charts/actions/workflows/release.yaml)

## <img src="https://github.com/obervinov/_templates/blob/main/icons/github-actions.png" width="25" title="github-actions"> GitHub Actions
| Name  | Version |
| ------------------------ | ----------- |
| GitHub Actions Templates | [v2.1.1](https://github.com/obervinov/_templates/tree/v2.1.1) |

## <img src="https://github.com/obervinov/content/blob/main/ico/helm_registry.png" width="30"> List of helm charts available for installation
<table>
  <tr>
    <th>Chart name</th>
    <th>Sources</th>
  </tr>
  <tr>
    <td><b>Helm Index</b></td>
    <td>https://obervinov.github.io/helm-charts/index.yaml</td>
  </tr>
  <tr>
    <td><b>Prometheus Operators</b></td>
    <td>https://github.com/obervinov/helm-charts/tree/main/src/promoperators</td>
  </tr>
  <tr>
    <td><b>Gitlab Runners</b></td>
    <td>https://github.com/obervinov/helm-charts/tree/main/src/gitlab-runners</td>
  </tr>
  <tr>
    <td><b>K8s Haproxy</b></td>
    <td>https://github.com/obervinov/helm-charts/tree/main/src/k8s-haproxy</td>
  </tr>
  <tr>
    <td><b>Jaeger Stack</b></td>
    <td>https://github.com/obervinov/helm-charts/tree/main/src/jaeger-stack</td>
  </tr>
  <tr>
    <td><b>Universal Template</b></td>
    <td>https://github.com/obervinov/helm-charts/tree/main/src/universal-template</td>
  </tr>
  <tr>
    <td><b>Kibana</b></td>
    <td>https://github.com/obervinov/helm-charts/tree/main/src/kibana</td>
  </tr>
  <tr>
    <td><b>Terraform Operator CRDs</b></td>
    <td>https://github.com/obervinov/helm-charts/tree/main/src/terraform-operator-crds</td>
  </tr>
  <tr>
    <td><b>WireGuard Operator</b></td>
    <td>https://github.com/obervinov/helm-charts/tree/main/src/wireguard-operator</td>
  </tr>
  <tr>
    <td><b>WireGuard Operator CRDs</b></td>
    <td>https://github.com/obervinov/helm-charts/tree/main/src/wireguard-operator-crds</td>
  </tr>
</table>

## <img src="https://github.com/obervinov/content/blob/main/ico/helm.svg" width="30"> How to add a repository to yourself and set a chart
# Simple registry
```sh
helm repo add obervinov https://obervinov.github.io/helm-charts/
```

# OCI registry
```sh
helm repo add obervinov oci://ghcr.io/obervinov/helm-charts
```

# Install a chart
```sh
helm repo update
helm search repo obervinov
helm install my-release obervinov/<chart-name>
```