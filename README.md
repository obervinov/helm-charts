# obervinov's helm-charts
This repository contains helm charts for all occasions.

This is a helm-registry for storing my helm-packages.

## How to add a repository to yourself and set a chart
```sh
helm repo add obervinov https://obervinov.github.io/helm-charts/
helm repo update
helm search repo obervinov
```
### How to build a json-schema (values.schema.json)
```sh
helm plugin install https://github.com/karuppiah7890/helm-schema-gen.git
helm schema-gen values.yaml > values.schema.json
```

### How to create a helm registry using github pages
```sh
echo -e “User-Agent: *\nDisallow: /” > robots.txt
helm package ./${CHART_PATH}
helm repo index --url https://github.com/obervinov/helm-charts/ .
cat index.yaml
```