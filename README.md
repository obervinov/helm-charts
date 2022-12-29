# <img src="https://github.com/obervinov/content/blob/main/ico/1945958.png" width="30">  obervinov's helm-charts
This repository contains helm charts for all occasions.

This is a helm-registry for storing my helm-packages.

## <img src="https://github.com/obervinov/content/blob/main/ico/helm_registry.png" width="30"> List of helm charts available for installation
<table>
  <tr>
    <th>Chart name</th>
    <th>Sources</th>
    <th>Package</th>
  </tr>
  <tr>
    <td><b>ServiceMonitor</b></td>
    <td>https://github.com/obervinov/helm-charts/tree/main/servicemonitor</td>
    <td>https://github.com/obervinov/helm-charts/blob/main/servicemonitor-1.0.0.tgz</td>
  </tr>
</table>

## <img src="https://github.com/obervinov/content/blob/main/ico/helm.svg" width="30"> How to add a repository to yourself and set a chart
```sh
helm repo add obervinov https://obervinov.github.io/helm-charts/
helm repo update
helm search repo obervinov
```
### <img src="https://github.com/obervinov/content/blob/main/ico/helm.svg" width="30"> How to automatic build and publish helm-package
```sh
./build-helm-package.sh
```
### <img src="https://github.com/obervinov/content/blob/main/ico/7264022.png" width="30"> How to build a json-schema (values.schema.json)
```sh
helm plugin install https://github.com/karuppiah7890/helm-schema-gen.git
helm schema-gen values.yaml > values.schema.json
```

### <img src="https://github.com/obervinov/content/blob/main/ico/4072573.png" width="30"> How to create a helm registry using github pages
```sh
echo -e “User-Agent: *\nDisallow: /” > robots.txt
helm package ./${CHART_PATH}
helm repo index --url https://obervinov.github.io/helm-charts/ .
# or
helm repo index --url https://obervinov.github.io/helm-charts/ --merge index.yaml .
# view helm index
cat index.yaml
```
