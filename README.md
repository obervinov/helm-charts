# <img src="https://github.com/obervinov/content/blob/main/ico/1945958.png" width="30">  obervinov's helm-charts
This repository contains helm charts for all occasions.

This is a helm-registry for storing my helm-packages.

[![pages-build-deployment](https://github.com/obervinov/helm-charts/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/obervinov/helm-charts/actions/workflows/pages/pages-build-deployment)

[![Build Helm charts bundle](https://github.com/obervinov/helm-charts/actions/workflows/helm.yaml/badge.svg)](https://github.com/obervinov/helm-charts/actions/workflows/helm.yaml)

[![Create GitHub Release](https://github.com/obervinov/helm-charts/actions/workflows/release.yaml/badge.svg)](https://github.com/obervinov/helm-charts/actions/workflows/release.yaml)

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
    <td><b>Promoperators</b></td>
    <td>https://github.com/obervinov/helm-charts/tree/main/src/promoperators</td>
  </tr>
  <tr>
    <td><b>Gitlab-runners</b></td>
    <td>https://github.com/obervinov/helm-charts/tree/main/src/gitlab-runners</td>
  </tr>
  <tr>
    <td><b>K8s-haproxy</b></td>
    <td>https://github.com/obervinov/helm-charts/tree/main/src/k8s-haproxy</td>
  </tr>
  <tr>
    <td><b>Jaeger-stack</b></td>
    <td>https://github.com/obervinov/helm-charts/tree/main/src/jaeger-stack</td>
  </tr>
  <tr>
    <td><b>Universal-template</b></td>
    <td>https://github.com/obervinov/helm-charts/tree/main/src/universal-template</td>
  </tr>
  <tr>
    <td><b>Kibana</b></td>
    <td>https://github.com/obervinov/helm-charts/tree/main/src/kibana</td>
  </tr>
</table>

## <img src="https://github.com/obervinov/content/blob/main/ico/helm.svg" width="30"> How to add a repository to yourself and set a chart
```sh
helm repo add obervinov https://obervinov.github.io/helm-charts/
# or
helm repo add obervinov https://helm-charts.charafee.cfd/helm-charts/
helm repo update
helm search repo obervinov
```
