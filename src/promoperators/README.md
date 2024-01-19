### Helm chart for fast deployment of custom ServiceMonitor's or PodMonitor's for Prometheus Operator

All available parameters and their values are described in [values.yaml](values.yaml)

Helm dependencies that are needed to scan the chart are in the dependencies section [Chart.yaml](Chart.yaml)

Supported:
- ServiceMonitor
- PodMonitor


### Examples
```yaml
global:
  apiName: monitoring.coreos.com
  apiVersion: v1

serviceMonitors:
  - name: istiod
    endpoints:
      - port: http-metrics
        interval: 30s
        scheme: http
    jobLabel: k8s-app
    namespaceSelectors:
      - istio-system
    labelSelectors:
      app: istiod

podMonitors:
  - name: istio-proxy
    podMetricsEndpoints:
      - port: http-envoy-prom
        path: /stats/prometheus
    jobLabel: k8s-app
    labelSelectors:
      istio-proxy: "true"
    namespaceSelector:
      any: true
```