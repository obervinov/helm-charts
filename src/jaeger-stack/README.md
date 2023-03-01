# Helm chart for jaeger-stack deployment in kubernetes
- Agent
- Collector
- Query
- Elasticsearch

**Attention! This chart only supports:**
- Elasticsearch as a span storage
- Gloo-gateway as a ingress-controller
____________________________________________________________________________________________________________
All available parameters and their values are described in [values.yaml](values.yaml)

Helm dependencies that are needed to scan the chart are in the dependencies section [Chart.yaml](Chart.yaml)